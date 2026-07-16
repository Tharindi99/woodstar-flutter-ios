import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wood_star_app/res/assets/assets.dart';

class QrScanFirestoreLoadingOverlay extends StatefulWidget {
  const QrScanFirestoreLoadingOverlay({
    super.key,
    required this.loading,
    this.minVisibleDuration = Duration.zero,
  });

  final bool loading;
  final Duration minVisibleDuration;

  @override
  State<QrScanFirestoreLoadingOverlay> createState() =>
      _QrScanFirestoreLoadingOverlayState();
}

class _QrScanFirestoreLoadingOverlayState
    extends State<QrScanFirestoreLoadingOverlay>
    with SingleTickerProviderStateMixin {
  bool _surfaceVisible = false;
  DateTime? _shownAt;
  Timer? _hideTimer;

  late final AnimationController _fadeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
  );
  late final Animation<double> _fade = CurvedAnimation(
    parent: _fadeController,
    curve: Curves.easeOut,
    reverseCurve: Curves.easeIn,
  );

  @override
  void initState() {
    super.initState();
    if (widget.loading) {
      _shownAt = DateTime.now();
      _surfaceVisible = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _fadeController.forward();
      });
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  void _cancelHide() {
    _hideTimer?.cancel();
    _hideTimer = null;
  }

  Future<void> _hideNow() async {
    if (!mounted) return;
    await _fadeController.reverse();
    if (mounted) setState(() => _surfaceVisible = false);
  }

  void _scheduleHide() {
    _cancelHide();
    final start = _shownAt;
    if (start == null) {
      unawaited(_hideNow());
      return;
    }
    final elapsed = DateTime.now().difference(start);
    final remaining = widget.minVisibleDuration - elapsed;
    final wait = remaining.isNegative ? Duration.zero : remaining;
    _hideTimer = Timer(wait, () {
      if (mounted) unawaited(_hideNow());
    });
  }

  @override
  void didUpdateWidget(QrScanFirestoreLoadingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.loading && !oldWidget.loading) {
      _cancelHide();
      _shownAt = DateTime.now();
      if (!_surfaceVisible) {
        setState(() => _surfaceVisible = true);
      }
      _fadeController.forward(from: _fadeController.value);
    } else if (!widget.loading && oldWidget.loading) {
      if (_surfaceVisible) {
        _scheduleHide();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_surfaceVisible) return const SizedBox.shrink();

    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return FadeTransition(
      opacity: _fade,
      child: AbsorbPointer(
        child: Material(
          type: MaterialType.transparency,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: ColoredBox(
                      color: Colors.black.withValues(alpha: 0.42),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 24, bottomInset + 16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFF151A22),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.22),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 160,
                              child: Lottie.asset(
                                Assets.qrLoader2,
                                fit: BoxFit.contain,
                                repeat: true,
                                alignment: Alignment.center,
                                errorBuilder:
                                    (
                                      BuildContext context,
                                      Object error,
                                      StackTrace? stackTrace,
                                    ) {
                                      return Icon(
                                        Icons.qr_code_scanner_rounded,
                                        size: 72,
                                        color: const Color(
                                          0xFF00C2D1,
                                        ).withValues(alpha: 0.9),
                                      );
                                    },
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'qr_scan_loading_title'.tr,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'qr_scan_loading_subtitle'.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.65),
                                fontSize: 13,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: const Color(
                                  0xFF00C2D1,
                                ).withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
