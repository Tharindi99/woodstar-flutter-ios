import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wood_star_app/data/quiz_session_warmup.dart';
import 'package:wood_star_app/res/assets/assets.dart';
import 'package:wood_star_app/res/colors/colors.dart';
import 'package:wood_star_app/screens/mainScreen/main-screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fade;
  late Animation<double> scale;
  late Animation<double> glow;

  late final Future<void> _quizWarmupBoth;
  static final Color _bottomDeep = Color.lerp(bgPrimary, Colors.black, 0.35)!;

  bool _isNoInternetDialogOpen = false;
  bool _hasNavigatedAway = false;
  Future<void>? _splashReadyFuture;

  @override
  void initState() {
    super.initState();
    _quizWarmupBoth = Future.wait<void>([
      QuizSessionWarmup.soundToPicture.prepare(),
      QuizSessionWarmup.pictureToSound.prepare(),
    ]);

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );

    fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOut),
      ),
    );

    scale = Tween<double>(
      begin: 0.38,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));

    glow = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, 0.95, curve: Curves.easeOut),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_startSplashFlow());
    });
  }

  Future<bool> _hasInternetConnection() async {
    try {
      final result = await Connectivity().checkConnectivity();
      return result.any((status) => status != ConnectivityResult.none);
    } on MissingPluginException {
      return _probeInternetReachability();
    } on PlatformException {
      return _probeInternetReachability();
    }
  }

  Future<bool> _probeInternetReachability() async {
    try {
      final response = await http
          .head(Uri.parse('https://www.google.com/generate_204'))
          .timeout(const Duration(seconds: 4));
      return response.statusCode == 204 || response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<void> _startSplashFlow() async {
    _splashReadyFuture ??= Future.wait<void>([
      controller.forward(),
      _quizWarmupBoth,
    ]);

    final connected = await _hasInternetConnection();
    if (!mounted) return;

    if (!connected) {
      await _showNoInternetDialog();
      return;
    }

    await _leaveSplashWhenReady();
  }

  Future<void> _showNoInternetDialog() async {
    if (_isNoInternetDialogOpen || !mounted) return;
    _isNoInternetDialogOpen = true;

    await Get.dialog<void>(
      PopScope(
        canPop: false,
        child: _NoInternetDialog(
          onTryAgain: () async {
            final connected = await _hasInternetConnection();
            if (!connected || !mounted) return;

            Get.back<void>();
            _isNoInternetDialogOpen = false;
            await _leaveSplashWhenReady();
          },
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.88),
    );

    _isNoInternetDialogOpen = false;
  }

  Future<void> _leaveSplashWhenReady() async {
    if (_hasNavigatedAway) return;

    try {
      await (_splashReadyFuture ??
          Future.wait<void>([controller.forward(), _quizWarmupBoth]));
    } catch (_) {}
    if (!mounted || _hasNavigatedAway) return;

    _hasNavigatedAway = true;
    Get.off(
      () => const WoodStarWelcomeScreen(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 220),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgPrimary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [bgPrimary, Color(0xFF0D1829), Color(0xFF0A1422)],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.15),
                radius: 0.95,
                colors: [
                  statusBarColor.withValues(alpha: 0.09),
                  globeBlue.withValues(alpha: 0.04),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.05,
                colors: [
                  Colors.transparent,
                  _bottomDeep.withValues(alpha: 0.55),
                  Colors.black.withValues(alpha: 0.35),
                ],
                stops: const [0.45, 0.82, 1.0],
              ),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return Opacity(
                  opacity: fade.value,
                  child: Transform.scale(
                    scale: scale.value,
                    filterQuality: FilterQuality.medium,
                    alignment: Alignment.center,
                    child: child,
                  ),
                );
              },
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  AnimatedBuilder(
                    animation: glow,
                    builder: (_, __) {
                      final g = glow.value;
                      return Container(
                        width: 268.w,
                        height: 268.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: globeBlue.withValues(alpha: 0.32 * g),
                              blurRadius: 36,
                              spreadRadius: 2,
                            ),
                            BoxShadow(
                              color: statusBarColor.withValues(alpha: 0.22 * g),
                              blurRadius: 56,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Container(
                    padding: EdgeInsets.all(18.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: borderGlow.withValues(alpha: 0.65),
                        width: 1.2,
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.1),
                          bgCard.withValues(alpha: 0.35),
                          Colors.white.withValues(alpha: 0.03),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.45),
                          blurRadius: 28,
                          offset: Offset(0, 14.h),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      Assets.appLogo2,
                      width: 196.w,
                      height: 196.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoInternetDialog extends StatefulWidget {
  const _NoInternetDialog({required this.onTryAgain});

  final Future<void> Function() onTryAgain;

  @override
  State<_NoInternetDialog> createState() => _NoInternetDialogState();
}

class _NoInternetDialogState extends State<_NoInternetDialog> {
  static const _orangeAccent = Color(0xFFFF9F1A);

  bool _isRetrying = false;

  Future<void> _handleTryAgain() async {
    if (_isRetrying) return;
    setState(() => _isRetrying = true);
    try {
      await widget.onTryAgain();
    } finally {
      if (mounted) setState(() => _isRetrying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 18.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0E1621), Color(0xFF151A24)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _orangeAccent.withValues(alpha: 0.55),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _orangeAccent.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: _orangeAccent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                color: _orangeAccent,
                size: 40.sp,
              ),
            ),
            14.verticalSpace,
            Text(
              'internet_connection_failed'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            10.verticalSpace,
            Text(
              'internet_connection_failed_message'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13.sp,
                height: 1.4,
              ),
            ),
            20.verticalSpace,
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isRetrying ? null : _handleTryAgain,
                  borderRadius: BorderRadius.circular(14),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isRetrying
                            ? [
                                const Color(0xFF00B2DA).withValues(alpha: 0.5),
                                const Color(0xFF2B85FC).withValues(alpha: 0.5),
                              ]
                            : const [
                                Color(0xFF00B2DA),
                                Color(0xFF2B85FC),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: _isRetrying
                          ? SizedBox(
                              width: 22.w,
                              height: 22.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: textPrimary,
                              ),
                            )
                          : Text(
                              'try_again'.tr,
                              style: TextStyle(
                                color: textPrimary,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
