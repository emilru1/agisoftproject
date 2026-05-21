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
    AqiField.no2,
    AqiField.co,
    AqiField.o3,
    AqiField.so2,
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

    if (data == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final Map<String, AqiField> availableFilters = {
      if (data.pm10 != null) "PM10": AqiField.pm10,
      if (data.pm2_5 != null) "PM2.5": AqiField.pm25,
      if (data.no2 != null) "NO2": AqiField.no2,
      if (data.co != null) "CO": AqiField.co,
      if (data.o3 != null) "O3": AqiField.o3,
      if (data.so2 != null) "SO2": AqiField.so2,
    };
    double cardWidth = MediaQuery.of(context).size.width * 0.4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Category("GENERAL INFO", 
        [

        
        Card(
          // color: Colors.transparent,
          // elevation: 0,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 105),
            child: Column(
              children: [
                Text(
                  data.city.split(',')[0],
                  style: const TextStyle(color: Colors.black, fontSize: 32),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "${data.general}",
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.style.description,
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),]
        ),

        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: availableFilters.entries.map((entry) {
            return FilterChip(
              label: Text(entry.key),
              selected: selectedFields.contains(entry.value),
              onSelected: (_) => toggleField(entry.value),
            );
          }).toList(),
        ),
        Category("PARTICLES TODAY", [
          if (selectedFields.contains(AqiField.pm10))
            Particlecard('PM10', data.pm10.toString()),

          if (selectedFields.contains(AqiField.pm25))
            Particlecard('PM2_5', data.pm2_5.toString()),
          if (selectedFields.contains(AqiField.no2))
            if (data.no2 != null) Particlecard('no2', data.no2!.toString()),
          if (selectedFields.contains(AqiField.co))
            if (data.co != null) Particlecard('co', data.co!.toString()),
          if (selectedFields.contains(AqiField.o3))
            if (data.o3 != null) Particlecard('o3', data.o3!.toString()),
          if (selectedFields.contains(AqiField.so2))
            if (data.so2 != null) Particlecard('so2', data.so2!.toString()),

          //Text(data.co.toString())
        ]),
      ],
    );
  }
}

enum AqiField { pm10, pm25, no2, co, o3, so2 }

final filters = {
  'PM10': AqiField.pm10,
  'PM2.5': AqiField.pm25,
  'no2': AqiField.no2,
  'co': AqiField.co,
  'o3': AqiField.o3,
  'so2': AqiField.so2,
};
