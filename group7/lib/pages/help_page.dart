import 'package:flutter/material.dart';
import 'package:group7/core/navbar.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    const imagePath1 = 'lib/assets/images/Help_pic1.png';
    const imagePath2 = 'lib/assets/images/Help_pic1.png';
    const imagePath3 = 'lib/assets/images/Help_pic1.png';

    return Scaffold(
      appBar: const Navbar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final sidePadding = constraints.maxWidth > 1000 ? 160.0 : 32.0;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: sidePadding,
              vertical: 15,
            ),
            child: const Column(
              children: [
                _HelpSection(
                  imagePath: imagePath1,
                  title: 'Why use this application?',
                  text:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                  imageOnLeft: true,
                ),

                SizedBox(height: 40),

                _HelpSection(
                  imagePath: imagePath2,
                  title: 'PM2.5 and PM10 and how it affects you?',
                  text:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                  imageOnLeft: false,
                ),

                SizedBox(height: 40),

                _HelpSection(
                  imagePath: imagePath3,
                  title: 'UN climate goals',
                  text:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                  imageOnLeft: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HelpSection extends StatelessWidget {
  final String imagePath;
  final String title;
  final String text;
  final bool imageOnLeft;

  const _HelpSection({
    required this.imagePath,
    required this.title,
    required this.text,
    required this.imageOnLeft,
  });

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(imagePath, height: 180, fit: BoxFit.contain);

    final textContent = Expanded(
      child: Column(
        crossAxisAlignment: imageOnLeft
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Text(
            title,
            textAlign: imageOnLeft ? TextAlign.left : TextAlign.right,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: imageOnLeft ? TextAlign.left : TextAlign.right,
            style: const TextStyle(fontSize: 18, height: 1.4),
          ),
        ],
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: imageOnLeft
          ? [image, const SizedBox(width: 40), textContent]
          : [textContent, const SizedBox(width: 40), image],
    );
  }
}
