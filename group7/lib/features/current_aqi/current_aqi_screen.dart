import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'aqi_provider.dart';


/*

Very basic UI Screen for current AQI, needs to be improved

*/


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
            colors: [data.style.color.withOpacity(0.7), data.style.color],
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
                  Text(data.style.label, style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text(data.style.description, style: TextStyle(color: Colors.white, fontSize: 12)),
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