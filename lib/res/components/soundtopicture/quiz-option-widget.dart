import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class QuizOptionTile extends StatelessWidget {
  final int index;
  final String imageUrl;
  final bool isSelected;
  final bool isCorrect;
  final bool revealAnswer;
  final VoidCallback onTap;
  final Color green;

  const QuizOptionTile({
    super.key,
    required this.index,
    required this.imageUrl,
    required this.isSelected,
    required this.isCorrect,
    required this.revealAnswer,
    required this.onTap,
    required this.green,
  });

  bool get _isNetwork =>
      imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

  bool get _showCorrectTile => revealAnswer && isCorrect;
  bool get _showWrongSelection => revealAnswer && isSelected && !isCorrect;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          /// Image Container
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _isNetwork
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, _) => Container(
                          color: Colors.white12,
                          alignment: Alignment.center,
                        ),
                        errorWidget: (context, _, __) => Container(
                          color: Colors.white12,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.broken_image_outlined,
                            color: Colors.white70,
                            size: 28,
                          ),
                        ),
                      )
                    : Image.asset(imageUrl, fit: BoxFit.cover),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _showCorrectTile
                          ? green
                          : (_showWrongSelection
                                ? Colors.red
                                : Colors.transparent),
                      width: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Overlay Color
          if (_showCorrectTile || _showWrongSelection)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: _showCorrectTile
                    ? green.withOpacity(0.35)
                    : Colors.red.withOpacity(0.35),
              ),
            ),

          /// Correct / Wrong Icon
          if (_showCorrectTile || _showWrongSelection)
            Positioned.fill(
              child: Center(
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: _showCorrectTile ? green : Colors.red,
                  child: Icon(
                    _showCorrectTile ? Icons.check : Icons.close,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),

          /// Option Number
          Positioned(
            top: 8,
            left: 8,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white,
              child: Text(
                "${index + 1}",
                style: const TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
