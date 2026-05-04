import 'package:flutter/material.dart';
import 'package:group7/core/navbar.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(),
      body: Center(
        child: Text(
          "Hej, här ska help_pagen vara",
          style: TextStyle(fontSize: 60),
        ),
      ),
    );
  }
}
