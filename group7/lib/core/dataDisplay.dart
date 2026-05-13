

import 'package:flutter/material.dart';
import 'package:group7/core/widgets/category.dart';
import 'package:group7/core/widgets/particle_card.dart';
import 'package:group7/features/current_aqi/aqi_provider.dart';
import 'package:provider/provider.dart';

class Datadisplay extends StatefulWidget {
  const Datadisplay({super.key});

  @override
  State<Datadisplay> createState() => _DatadisplayScreenState();
}

class _DatadisplayScreenState extends State<Datadisplay> {

  // Multiple selections
  Set<AqiField> selectedFields = {
    AqiField.pm10,
    AqiField.pm25,
  };

  void toggleField(AqiField field) {
    setState(() {
      if (selectedFields.contains(field)) {
        selectedFields.remove(field);
      } else {
        selectedFields.add(field);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final aqiProvider = context.watch<AqiProvider>();
    final data = aqiProvider.currentData;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        const SizedBox(height: 20),
        Text("${data!.general}", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
        Text(data.style.description, style: TextStyle(fontSize: 12), textAlign: TextAlign.center,),
        SizedBox(height:20),
        /// FILTER BUTTONS
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: filters.entries.map((entry) {
            return FilterChip(
              label: Text(entry.key),
              selected: selectedFields.contains(entry.value),
              onSelected: (_) => toggleField(entry.value),
            );
          }).toList(),
        ),
        Category("PARTICLES TODAY", [
            if (selectedFields.contains(AqiField.pm10))
              Particlecard('PM10', data.pm10),

            if (selectedFields.contains(AqiField.pm25))
              Particlecard('PM2_5', data.pm2_5)
          ],)
        ,
      ],
    );
  }
}
enum AqiField {
  pm10,
  pm25,
}
final filters = {
  'PM10': AqiField.pm10,
  'PM2.5': AqiField.pm25,
};