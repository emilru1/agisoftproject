
import 'package:flutter/material.dart';
class Navbar extends StatelessWidget implements PreferredSizeWidget{ 
  const Navbar({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppBar(
      //centerTitle: true,
      backgroundColor: Colors.yellow,
      title:Row(
        children: [
          Text(
            "AirQualityTracker",
            style: TextStyle(
            color: Colors.black,
          )),
            
            ]
        ,) 
    );
    }
    
      @override
      Size get preferredSize => const Size.fromHeight(60);
  
}