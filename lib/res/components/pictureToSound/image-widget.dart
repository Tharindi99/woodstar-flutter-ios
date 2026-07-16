import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ImageCardWidget extends StatelessWidget {
  /// Network URL or `assets/...` path.
  final String imageUrl;

  const ImageCardWidget({super.key, required this.imageUrl});

  bool get _isNetwork =>
      imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

  String get _assetSource {
    final normalized = imageUrl.trim().replaceAll('\\', '/');
    if (normalized.startsWith('assets/')) return normalized;
    return 'assets/$normalized';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF4B001F), Color(0xFF8B003A)],
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white12,
            child: Icon(Icons.remove_red_eye, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            'pic_to_sound_title'.tr,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'pic_to_sound_subtitle'.tr,
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xFF8B003A), width: 2.2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _isNetwork
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        height: 160.h,
                        width: double.infinity,
                        placeholder: (context, url) => Container(
                          height: 160.h,
                          width: double.infinity,
                          color: Colors.grey[800],
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                Color(0xFFFF4F9A),
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 160.h,
                          width: double.infinity,
                          color: Colors.grey[700],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.white54,
                            ),
                          ),
                        ),
                      )
                    : Image.asset(
                        _assetSource,
                        height: 160.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 160.h,
                          width: double.infinity,
                          color: Colors.grey[700],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.white54,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
