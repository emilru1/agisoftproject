import 'package:flutter/material.dart';

class Particlecard extends StatelessWidget{
  final String title;
  final int value;
  const Particlecard(this.title, this.value, {super.key});

  //String title;
  //const ParticleCard(this.title, {super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: .3),
            blurRadius: 20, // soften the shadow
            spreadRadius: 0, //extend the shadow
          ),
        ],
      ),
      child: Card(     
        child: Padding(padding: EdgeInsets.all(10), 
          child: SizedBox(
          width: 100, height: 100, child: 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 20),),
              Text("Good",style: const TextStyle(fontSize: 17),),
              Text('$value' " μg/m3", style: const TextStyle(fontSize: 17),)
            ],
          )
          ),)
      ),
    )
    ;
  }
}