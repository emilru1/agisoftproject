import 'package:flutter/material.dart';
import 'package:group7/features/current_aqi/aqi_provider.dart';
import 'package:provider/provider.dart';

class CheckboxExample extends StatefulWidget {
  const CheckboxExample({super.key});

  @override
  State<CheckboxExample> createState() => _CheckboxExampleState();
}

class _CheckboxExampleState extends State<CheckboxExample> {
  bool? isChecked = true;
  bool pm2_5 = true;
  bool pm10 = true;

  @override
  Widget build(BuildContext context) {
    final aqiProvider = context.watch<AqiProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Checkbox(
          value: pm2_5,
          onChanged: (bool? value) {
            setState(() {
              pm2_5 = value!;
            });
          },
        ),
        Checkbox(
          isError: true,
          tristate: true,
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value;
            });
          },
        ),
        Checkbox(
          isError: true,
          tristate: true,
          value: isChecked,
          onChanged: null,
        ),
      ],
    );
  }
}