import 'package:flutter/material.dart';

class AqiModel {
  final int aqi;
  final String city;
  final DateTime timestamp;

  AqiModel({required this.aqi, required this.city, required this.timestamp});


  factory AqiModel.fromJson(Map<String, dynamic> json) {
    return AqiModel(
      aqi: json['data']['aqi'],
      city: json['data']['city']['name'],
      timestamp: DateTime.now(),
    );
  }

 
  Color get color {
    if (aqi <= 50) return Colors.green;
    if (aqi <= 100) return Colors.orange;
    if (aqi <= 150) return Colors.yellow;
    if (aqi <= 200) return Colors.red;
    if (aqi <= 300) return Colors.purple;
    return Color(0xFF800000);
  }

  String get message {
    if (aqi <= 50) return "Clean air";
    if (aqi <= 100) return "Kinda clean";
    if (aqi <= 150) return "Mid";
    if (aqi <= 200) return "Kinda bad";
    if (aqi <= 300) return "bad";
    return "Deadly";
  }
}