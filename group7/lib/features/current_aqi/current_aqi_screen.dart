import 'package:flutter/material.dart';
import 'package:group7/core/dataDisplay.dart';
import 'package:provider/provider.dart';

import 'aqi_provider.dart';
import 'package:group7/core/widgets/pollutantText.dart';
import 'package:group7/core/navbar.dart';


class CurrentAqiScreen extends StatefulWidget {
  const CurrentAqiScreen({super.key});

  @override
  State<CurrentAqiScreen> createState() => _CurrentAqiScreenState();
}

class _CurrentAqiScreenState extends State<CurrentAqiScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<AqiProvider>().refreshAqi();
    });
  }

  @override
  Widget build(BuildContext context) {

    final aqiProvider = context.watch<AqiProvider>();

    if (aqiProvider.isLoading) {
      return Scaffold(
        appBar: Navbar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final data = aqiProvider.currentData;

    if (data == null) {
      return Scaffold(
        appBar: Navbar(),
        body: Center(
          child: ElevatedButton(
            onPressed: () => aqiProvider.refreshAqi(),
            child: const Text("Hämta luftkvalitet"),
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
            colors: [
              data.style.color.withValues(alpha: 0.7),
              data.style.color,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                data.city,
                style: const TextStyle(color: Colors.white, fontSize: 32),
                textAlign: TextAlign.center,
              ),

              Column(
                children: [
                  Datadisplay(),

                  const SizedBox(height: 40),

                  Text(
                    data.threeDayForecast[0].date,
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),

                  const SizedBox(
                    width: 300,
                    child: Divider(color: Colors.white, thickness: 2),
                  ),

                  const SizedBox(height: 12),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                icon: const Icon(Icons.refresh, color: Colors.white, size: 40),
                onPressed: () => aqiProvider.refreshAqi(),
              ),
              ElevatedButton(
                onPressed: () {
                  //context.read<AqiProvider>().testApi();
                },
                child: const Text("Test Django API"),
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
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Column(
      children: [
        Text(
          forecast.date,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        _buildMetricRow("Avg", forecast.pm2_5.avg, forecast.pm10.avg),
        _buildMetricRow("Max", forecast.pm2_5.max, forecast.pm10.max),
        _buildMetricRow("Min", forecast.pm2_5.min, forecast.pm10.min),
      ],
    ),
  );
}

Widget _buildMetricRow(String label, dynamic pm25, dynamic pm10) {
  return Row(
    children: [
      Text("$label: ", style: const TextStyle(color: Colors.white70)),
      PollutantText(value: pm25, subscript: "2.5"),
      PollutantText(value: pm10, subscript: "10"),
    ],
  );
}