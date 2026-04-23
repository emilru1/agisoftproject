import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:group7/features/current_aqi/aqi_provider.dart';
import 'package:group7/features/current_aqi/current_aqi_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AqiProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AQI App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: CurrentAqiScreen(),
    );
  }
}