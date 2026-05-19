import 'package:flutter/material.dart';
import 'package:group7/core/navbar.dart';
import 'dart:convert';

import 'help_information.dart';
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    const imagePath1 = 'lib/assets/images/Help_pic1.png';
    const imagePath2 = 'lib/assets/images/particles.jpg';
    const imagePath3 = 'lib/assets/images/ungoal3.png';
    const imagePath4 = 'lib/assets/images/ungoal11.png';
    final info = jsonDecode(helpJson);
    return Scaffold(
      appBar: const Navbar(activePage: 'learn'),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final sidePadding = constraints.maxWidth > 1000 ? 160.0 : 32.0;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: sidePadding,
              vertical: 15,
            ),
            child: Column(
              children: [
                _HelpSection(
                  imagePath: imagePath1,
                  title: 'Why use this application?',
                  text:info["why"],
                  imageOnLeft: true,
                ),

                SizedBox(height: 40),

                _HelpSection(
                  imagePath: imagePath2,
                  title: 'PM2.5 and PM10 and how it affects you?',
                  text:
                      info["pm2_5"]["description"]+info["pm2_5"]["short_risk"]+info["pm2_5"]["long_risk"] +"\n\n" +
                      info["pm_10"]["description"]+info["pm_10"]["short_risk"]+info["pm_10"]["long_risk"],
                  imageOnLeft: false,
                ),

                SizedBox(height: 40),

                _HelpSection(
                  imagePaths: [imagePath3,imagePath4],
                  title: 'UN climate goals',
                  text:
                      info["un"]["goal3"] + "\n\n" + info["un"]["goal11"],
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
  final String? imagePath;
  final List<String>? imagePaths;
  final String title;
  final String text;
  final bool imageOnLeft;

  const _HelpSection({
    this.imagePath,
    this.imagePaths,
    required this.title,
    required this.text,
    required this.imageOnLeft,
  });

  @override
  Widget build(BuildContext context) {
    
    final isSmallScreen = MediaQuery.of(context).size.width < 768;

    Widget imageWidget;
    // If multiple images exist
    if (imagePaths != null) {
      imageWidget = Row(
        mainAxisAlignment: isSmallScreen ? MainAxisAlignment.center : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: imagePaths!
            .map(
              (path) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Image.asset(
                  path,
                  height: isSmallScreen? 140:180,
                  fit: BoxFit.contain,
                ),
              ),
            )
            .toList(),
      );
    } else {
      imageWidget = Image.asset(
        imagePath!,
        height: isSmallScreen? 160:180,
        fit: BoxFit.contain,
      );
    }


    final textContent = Center(
      child: Column(
        crossAxisAlignment: isSmallScreen
          ? CrossAxisAlignment.center // Centered layout on mobile
          : (imageOnLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end),
        children: [
          Text(
            title,
            textAlign: isSmallScreen
              ? TextAlign.center
              : (imageOnLeft ? TextAlign.left : TextAlign.right),
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: isSmallScreen
              ? TextAlign.center
              : (imageOnLeft ? TextAlign.left : TextAlign.right),
            style: const TextStyle(fontSize: 18, height: 1.4),
          ),
        ],
      ),
    );

    if (isSmallScreen) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: imageWidget),
          const SizedBox(height: 24),
          textContent 
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: imageOnLeft
            ? [
                imageWidget,
                const SizedBox(width:40),
                Expanded(child: textContent),
              ]
            : [
                Expanded(child: textContent),
                const SizedBox(width:40),
                imageWidget
              ],
      );
    }
  }
}
