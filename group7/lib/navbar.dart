import 'package:flutter/material.dart';

class Navbar extends StatefulWidget implements PreferredSizeWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _NavbarState extends State<Navbar> {
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.yellow,
      title: isSearching
          ? 
          SearchBar(
            leading: Icon(Icons.search),
            onSubmitted: (value) {
              setState(() {
                // Filter search
                isSearching = !isSearching;
              });
            },
          )
          : const Text(
              "AirQualityTracker",
              style: TextStyle(color: Colors.black),
            ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              isSearching = !isSearching;
            });
          },
          icon: isSearching ? Icon(Icons.close) : Icon(Icons.search),
        )
      ],
    );
  }
}