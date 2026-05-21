import 'package:flutter/material.dart';
import 'package:group7/theme/app_theme.dart';

class PollutantText extends StatelessWidget {
  final int? value;
  final String label; // "PM"
  final String subscript;
  final double fontSize;
  final Color color;

  const PollutantText({
    super.key,
    this.value,
    this.label = "PM",
    required this.subscript,
    this.fontSize = 18,
    this.color = AppTheme.white,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = value?.toString() ?? "";
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(text: '$displayValue$label'),
          WidgetSpan(
            child: Transform.translate(
              offset: Offset(0, fontSize * 0.15),
              child: Text(
                subscript,
                style: TextStyle(
                  color: color,
                  fontSize: fontSize * 0.6,
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
