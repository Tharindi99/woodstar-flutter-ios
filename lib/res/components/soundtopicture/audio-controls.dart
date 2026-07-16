import 'package:flutter/material.dart';

class AudioControls extends StatelessWidget {
  final double value;
  const AudioControls({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: ShaderMask(
        shaderCallback: (bounds) {
          return const LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFFFF0080)],
          ).createShader(bounds);
        },
        child: LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.white24,
          minHeight: 8,
          valueColor: const AlwaysStoppedAnimation(Colors.white),
        ),
      ),
    );
  }
}
