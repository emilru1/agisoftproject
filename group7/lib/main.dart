import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:group7/features/current_aqi/providers/aqi_provider.dart';
import 'package:group7/features/current_aqi/screens/current_aqi_screen.dart';

void main() {
  runApp(
  
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AqiProvider()..refreshAqi()),
      ],
      child: const MyAqiApp(),
    ),
  );
}

class MyAqiApp extends StatelessWidget {
  const MyAqiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luftkvalitet',
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CurrentAqiScreen(), 
    );
  }
}