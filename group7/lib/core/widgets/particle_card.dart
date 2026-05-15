import 'package:flutter/material.dart';
import 'package:group7/features/current_aqi/aqi_style.dart';

class Particlecard extends StatelessWidget{
  final String title;
  final int value;
  const Particlecard(this.title, this.value, {super.key});

  //String title;
  //const ParticleCard(this.title, {super.key});
  @override
  Widget build(BuildContext context) {
    AqiStyle style = AqiStyle.fromAqi(value);
    double cardWidth = ((MediaQuery.of(context).size.width * 0.4) - 60 ) /3;

    return Container(
      width: cardWidth, height: 120, 
      constraints: const BoxConstraints(minWidth: 310 / 2),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9), // Semi-transparent look
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(padding: EdgeInsets.all(10), 
          child: SizedBox(
          child: 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 20),),
              Divider(
                height: 2,           // Adjust this to match your text height
                color: Colors.grey.withValues(alpha: 0.3), ),
              Text('$value', style: TextStyle(
                  color: Colors.black,
                  fontSize: 24, 
                  fontWeight: FontWeight.w800,
                ),),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: style.color.withValues(alpha: 0.2), // Subtle background
                      borderRadius: BorderRadius.circular(6),   // Rounded corners
                      border: Border.all(color: style.color, width: 1),
                    ),
                    child: Text(
                      style.label,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10, // Tiny font
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              //Text("μg/m3")
            ],
          )
          ),)
    )
    ;
  }
}