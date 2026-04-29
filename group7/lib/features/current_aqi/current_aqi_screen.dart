import 'package:flutter/material.dart';
import 'package:group7/core/widgets/pollutantText.dart';
import 'package:provider/provider.dart';
import 'aqi_provider.dart';
import 'package:group7/core/navbar.dart';

/*

Very basic UI Screen for current AQI, needs to be improved

*/


class CurrentAqiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final aqiProvider = context.watch<AqiProvider>();

    if (aqiProvider.isLoading) {
      return Scaffold(
        appBar: Navbar(),
        body: Center(child: CircularProgressIndicator()));
    }

    final data = aqiProvider.currentData;
    if (data == null) {
      return Scaffold(
        appBar: Navbar(),
        body: Center(
          child: ElevatedButton(
            onPressed: () => aqiProvider.refreshAqi(),
            child: Text("Hämta luftkvalitet"),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: Navbar(),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [data.style.color.withValues(alpha: 0.7), data.style.color],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(data.city, style: TextStyle(color: Colors.white, fontSize: 32),textAlign: TextAlign.center),
              Column(
                children: [
                  Text("${data.general}", style: TextStyle(color: Colors.white, fontSize: 100, fontWeight: FontWeight.bold)),
                  Text(data.style.label, style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text(data.style.description, style: TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center,),
                  SizedBox(height: 30),
                  PollutantText(value: data.pm2_5, subscript: "2.5"),
                  SizedBox(height:8),
                  PollutantText(value: data.pm10, subscript: "10" ),
                  SizedBox(height: 40),
                  Text(data.threeDayForecast[0].date, style: TextStyle(color: Colors.white, fontSize: 24)),
                  SizedBox(
                    width:300,
                    child: Divider(
                      color: Colors.white,
                      thickness: 2,
                    )
                  ),
                  SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16), // Gives space at start/end of scroll
                    child: Row(
                      children: [
                        _buildForecastDay(data.threeDayForecast[1]),
                        _buildForecastDay(data.threeDayForecast[2]),
                        _buildForecastDay(data.threeDayForecast[3]),
                      ],
                    ),
                  ),
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
Widget _buildForecastDay(dynamic forecast) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: Column(
      spacing: 2,
      children: [
        Text(forecast.date, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        _buildMetricRow("Avg", forecast.pm2_5.avg, forecast.pm10.avg),
        _buildMetricRow("Max", forecast.pm2_5.max, forecast.pm10.max),
        _buildMetricRow("Min", forecast.pm2_5.min, forecast.pm10.min),
      ],
    ),
  );
}

Widget _buildMetricRow(String label, dynamic pm25, dynamic pm10) {
  return Row(
    spacing: 6,
    children: [
      Text("$label:  ", style: TextStyle(color: Colors.white70, fontSize: 16)),
      PollutantText(value: pm25, subscript: "2.5"),
      PollutantText(value: pm10, subscript: "10"),
    ],
  );
}
