import 'package:flutter/material.dart';
import 'package:group7/theme/app_theme.dart';

class Category extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const Category(this.title, this.children, {super.key});

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.4;

    return Container(
      width: cardWidth,
      constraints: const BoxConstraints(minWidth: 360),
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white60, // Semi-transparent look
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.white24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          SizedBox(width: 8, height: 8),

          Wrap(spacing: 8, runSpacing: 8, children: children + children),
        ],
      ),
    );
  }
}
