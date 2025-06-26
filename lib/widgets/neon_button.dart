import 'package:flutter/material.dart';

class NeonButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isDisabled;

  const NeonButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 400 ? 12 : 14; // Уменьшаем шрифт для телефонов
    double iconSize = screenWidth < 400 ? 20 : 24;

    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled ? Colors.grey[400] : Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadowColor: isDisabled ? Colors.grey : Colors.blueAccent,
        elevation: 5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: iconSize,
              color: isDisabled ? Colors.grey[200] : Colors.white,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                color: isDisabled ? Colors.grey[200] : Colors.white,
              ),
              textAlign: TextAlign.center,
              softWrap: true, // Разрешаем перенос текста
              maxLines: 2, // Максимум 2 строки
              overflow: TextOverflow.ellipsis, // Эллипсис для переполнения
            ),
          ),
        ],
      ),
    );
  }
}