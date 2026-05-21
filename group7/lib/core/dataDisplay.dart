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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
          color: Colors.transparent,
          elevation: 0,
          //elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 64),
            child: Column(
              children: [
                Text(
                  data.city,
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
        ),

        const SizedBox(height: 16),
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
              Particlecard('PM10', data.pm10.toString()),

            if (selectedFields.contains(AqiField.pm25))
              Particlecard('PM2_5', data.pm2_5.toString()),
            if (selectedFields.contains(AqiField.no2))
                if (data.no2 != null)
                  Particlecard('no2', data.no2!.toString()),
            if (data.co != null)
             Particlecard('co', data.co!.toString()),
            if (data.o3 != null)
             Particlecard('o3', data.o3!.toString()),
            if (data.so2 != null)
             Particlecard('so2', data.so2!.toString()),
            //Text(data.co.toString())

          ],)
        ,
      ],
    );
  }
}
enum AqiField {
  pm10,
  pm25,
  no2,
}
final filters = {
  'PM10': AqiField.pm10,
  'PM2.5': AqiField.pm25,
  'no2': AqiField.no2,
};
