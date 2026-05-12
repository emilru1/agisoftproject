import 'package:flutter/material.dart';
import 'package:free_map/free_map.dart';

class Category extends StatelessWidget{
  final String title;
  final List<Widget> children;
  const Category(this.title, this.children, {super.key});

  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(10)), 
      ),
      child: Wrap(children: children,),
    )
    ;
  }

  
}