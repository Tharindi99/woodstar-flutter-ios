import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wood_star_app/res/colors/colors.dart';

class FeatureCard extends StatelessWidget {
  final Color glowColor;
  final Color iconBg;
  final IconData icon;
  final String title;
  final String titleEmoji;
  final String highlight;
  final String description;
  final String footer;
  final Color subtitleColor;
  final VoidCallback onTap;
  final bool compact;

  const FeatureCard({
    super.key,
    required this.glowColor,
    required this.iconBg,
    required this.icon,
    required this.title,
    required this.titleEmoji,
    required this.highlight,
    required this.description,
    required this.footer,
    required this.subtitleColor,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCard(
        pad: 10.w,
        iconSize: 40.w,
        iconInner: 24.sp,
        titleSize: 14.sp,
        highlightSize: 12.5.sp,
        bodySize: 11.5.sp,
        footerSize: 11.sp,
        gapSm: 4.h,
        gapMd: 5.h,
        descriptionMaxLines: 2,
        descriptionHeight: 1.25,
        clipText: true,
        iconGap: 10.w,
      );
    }

    return _buildCard(
      pad: 16,
      iconSize: 50,
      iconInner: 30,
      titleSize: 16,
      highlightSize: 14.5,
      bodySize: 13.5,
      footerSize: 13.sp,
      gapSm: 6,
      gapMd: 8,
      descriptionMaxLines: null,
      descriptionHeight: 1.5,
      clipText: false,
      iconGap: 14,
    );
  }

  Widget _buildCard({
    required double pad,
    required double iconSize,
    required double iconInner,
    required double titleSize,
    required double highlightSize,
    required double bodySize,
    required double footerSize,
    required double gapSm,
    required double gapMd,
    required int? descriptionMaxLines,
    required double descriptionHeight,
    required bool clipText,
    required double iconGap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.6),
            blurRadius: 0.5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: glowColor.withOpacity(0.25),
          highlightColor: glowColor.withOpacity(0.08),
          onTap: onTap,
          child: Ink(
            padding: EdgeInsets.all(pad),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [bgPrimary, bgPrimary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: glowColor, width: 0.1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: iconSize,
                  width: iconSize,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: iconInner, color: Colors.white),
                ),
                SizedBox(width: iconGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (clipText)
                            Flexible(
                              child: Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: titleSize,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimary,
                                ),
                              ),
                            )
                          else
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: titleSize,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                              ),
                            ),
                          const SizedBox(width: 6),
                          Text(titleEmoji),
                        ],
                      ),
                      SizedBox(height: gapSm),
                      Text(
                        highlight,
                        maxLines: clipText ? 1 : null,
                        overflow:
                            clipText ? TextOverflow.ellipsis : TextOverflow.visible,
                        style: TextStyle(
                          color: subtitleColor,
                          fontWeight: FontWeight.w600,
                          fontSize: highlightSize,
                        ),
                      ),
                      SizedBox(height: gapMd),
                      Text(
                        description,
                        maxLines: descriptionMaxLines,
                        overflow: clipText && descriptionMaxLines != null
                            ? TextOverflow.ellipsis
                            : TextOverflow.visible,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          height: descriptionHeight,
                          fontSize: bodySize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: gapMd),
                      Text(
                        footer,
                        maxLines: clipText ? 1 : null,
                        overflow:
                            clipText ? TextOverflow.ellipsis : TextOverflow.visible,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.45),
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: footerSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
