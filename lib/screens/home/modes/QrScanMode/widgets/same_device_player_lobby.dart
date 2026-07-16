import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wood_star_app/res/colors/colors.dart';

class SameDevicePlayerLobby extends StatelessWidget {
  const SameDevicePlayerLobby({
    super.key,
    required this.hostNickname,
    required this.guestNicknames,
    required this.maxGuests,
    required this.inputController,
    required this.addingInProgress,
    required this.onAddTap,
    required this.onRemoveGuest,
    this.embedInDialog = false,
  });

  final String hostNickname;
  final List<String> guestNicknames;
  final int maxGuests;
  final TextEditingController inputController;
  final bool addingInProgress;
  final VoidCallback onAddTap;
  final ValueChanged<String> onRemoveGuest;
  final bool embedInDialog;

  static const _purple = Color(0xFF9B5CFF);
  static const _purpleDeep = Color(0xFFB455FF);
  static const _cyan = Color(0xFF00C2D1);

  @override
  Widget build(BuildContext context) {
    final hostLabel = hostNickname.trim().isEmpty
        ? 'qr_same_device_host_placeholder'.tr
        : hostNickname.trim();
    final canAddMore = guestNicknames.length < maxGuests;

    final formColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!embedInDialog) ...[
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: _purpleDeep.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.groups_2_rounded,
                  color: textPrimary,
                  size: 22.sp,
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'qr_same_device_lobby_title'.tr,
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    2.verticalSpace,
                    Text(
                      'qr_same_device_lobby_subtitle'.tr,
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 11.sp,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white24),
                ),
                child: Text(
                  '${guestNicknames.length}/$maxGuests',
                  style: TextStyle(
                    color: _cyan,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          12.verticalSpace,
        ] else ...[
          Text(
            'qr_same_device_dialog_hint'.tr,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 12.sp,
              height: 1.35,
            ),
          ),
          12.verticalSpace,
        ],
        _playerRow(
          label: 'qr_same_device_host_label'.tr,
          name: hostLabel,
          isHost: true,
          onRemove: null,
        ),
        if (guestNicknames.isNotEmpty) ...[
          8.verticalSpace,
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'qr_same_device_guests_label'.tr,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          6.verticalSpace,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final g in guestNicknames) _guestChip(g, onRemoveGuest),
            ],
          ),
        ],
        12.verticalSpace,
        TextField(
          controller: inputController,
          enabled: canAddMore && !addingInProgress,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) =>
              canAddMore && !addingInProgress ? onAddTap() : null,
          style: TextStyle(color: textPrimary, fontSize: 14.sp),
          cursorColor: _cyan,
          decoration: InputDecoration(
            isDense: true,
            hintText: 'qr_same_device_add_hint'.tr,
            hintStyle: TextStyle(color: Colors.white38, fontSize: 13.sp),
            filled: true,
            fillColor: const Color(0xFF0E1621),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 12.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _cyan, width: 1.2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
        ),
        10.verticalSpace,
        SizedBox(
          height: 44.h,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: (canAddMore && !addingInProgress) ? onAddTap : null,
              borderRadius: BorderRadius.circular(14),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: canAddMore && !addingInProgress
                        ? const [Color(0xFF00B2DA), Color(0xFF2B85FC)]
                        : [Colors.grey.shade800, Colors.grey.shade900],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: addingInProgress
                      ? SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: textPrimary,
                          ),
                        )
                      : Text(
                          'qr_same_device_add_button'.tr,
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );

    if (embedInDialog) {
      return formColumn;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A0F14), Color(0xFF151A24)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _purple.withValues(alpha: 0.55), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: _purple.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: formColumn,
    );
  }

  Widget _playerRow({
    required String label,
    required String name,
    required bool isHost,
    required VoidCallback? onRemove,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1621),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isHost ? _cyan.withValues(alpha: 0.35) : Colors.white12,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isHost ? Icons.star_rounded : Icons.person_outline_rounded,
            color: isHost ? _cyan : Colors.white54,
            size: 20.sp,
          ),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                2.verticalSpace,
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _guestChip(String nick, void Function(String) onRemove) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(left: 10.w, right: 4.w, top: 6.h, bottom: 6.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1C2536),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _purple.withValues(alpha: 0.45)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              nick,
              style: TextStyle(
                color: textPrimary,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            4.horizontalSpace,
            InkWell(
              onTap: () => onRemove(nick),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: EdgeInsets.all(4.r),
                child: Icon(
                  Icons.close_rounded,
                  size: 18.sp,
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
