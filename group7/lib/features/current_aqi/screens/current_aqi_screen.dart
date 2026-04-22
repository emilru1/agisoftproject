import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/aqi_provider.dart';

class CurrentAqiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final aqiProvider = context.watch<AqiProvider>();

    if (aqiProvider.isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final data = aqiProvider.currentData;
    if (data == null) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () => aqiProvider.refreshAqi(),
            child: Text("Hämta luftkvalitet"),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [data.color.withOpacity(0.7), data.color],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(data.city, style: TextStyle(color: Colors.white, fontSize: 32)),
              Column(
                children: [
                  Text("${data.aqi}", style: TextStyle(color: Colors.white, fontSize: 100, fontWeight: FontWeight.bold)),
                  Text(data.message, style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.white, size: 40),
                onPressed: () => aqiProvider.refreshAqi(),
              )
            ],
          ),
        ),
      ),
    );
  }
}