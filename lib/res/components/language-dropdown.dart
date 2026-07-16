import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/language-controller.dart';

class LanguageDropdown extends StatefulWidget {
  const LanguageDropdown({super.key});

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  final controller = Get.put(LanguageController());
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
      controller.isOpen.value = true;
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
      controller.isOpen.value = false;
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder:
          (context) => GestureDetector(
            onTap: _toggleDropdown,
            behavior: HitTestBehavior.translucent,
            child: Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  Positioned(
                    left: offset.dx,
                    top: offset.dy + size.height + 5,
                    width: 220,
                    child: Material(
                      borderRadius: BorderRadius.circular(16),
                      elevation: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF2A2F3A), Color(0xFF0F172A)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children:
                              controller.languages.map((lang) {
                                final isSelected =
                                    controller.selected.value == lang;
                                return Material(
                                  color:
                                      isSelected
                                          ? Colors.white12
                                          : Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: () {
                                      controller.select(lang);
                                      _toggleDropdown();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            lang.code,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 14),
                                          Text(
                                            lang.label,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
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

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Obx(
        () => GestureDetector(
          onTap: _toggleDropdown,
          behavior: HitTestBehavior.translucent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.language, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Text(
                  "${controller.selected.value.code}  ${controller.selected.value.label}",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 6),
                Icon(
                  controller.isOpen.value
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white70,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
