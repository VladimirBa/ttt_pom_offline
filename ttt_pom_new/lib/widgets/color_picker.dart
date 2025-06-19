import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;
  final List<Color> colors;

  const ColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: colors.map((color) {
        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: color == selectedColor ? Colors.white : Colors.transparent,
                width: 2,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}