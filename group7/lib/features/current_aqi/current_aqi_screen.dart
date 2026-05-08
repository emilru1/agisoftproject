import 'package:flutter/material.dart';
import 'package:group7/api-calls/http_requests.dart';
import 'package:provider/provider.dart';

import 'aqi_provider.dart';
import 'package:group7/core/widgets/pollutantText.dart';
import 'package:group7/core/navbar.dart';
import 'package:group7/features/user/user_provider.dart';


class CurrentAqiScreen extends StatefulWidget {
  final double? lat;
  final double? lon;

  const CurrentAqiScreen({
    super.key,
    this.lat,
    this.lon,
  });

  @override
  State<CurrentAqiScreen> createState() => _CurrentAqiScreenState();
}

class _CurrentAqiScreenState extends State<CurrentAqiScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (widget.lat != null && widget.lon != null) {
        await context
            .read<AqiProvider>()
            .fetchAqiForCoordinates(widget.lat!, widget.lon!);
      } else {
        await context.read<AqiProvider>().refreshAqi();
      }
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                data.city,
                style: const TextStyle(color: Colors.white, fontSize: 32),
                textAlign: TextAlign.center,
              ),

              Column(
                children: [
                  Text(
                    "${data.general}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    data.style.label,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    data.style.description,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  PollutantText(value: data.pm2_5, subscript: "2.5"),
                  const SizedBox(height: 8),
                  PollutantText(value: data.pm10, subscript: "10"),

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
                onPressed: () async {
                  final username = context.read<UserProvider>().username;

                  if (username == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("No user selected"),
                      ),
                    );
                    return;
                  }

                  try {
                    final result = await ApiService.createFavourite(
                      username: username,
                      lat: data.lat.toString(),
                      lon: data.lon.toString(),
                    );

                    print(result);

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Favourite added"),
                      ),
                    );
                  } catch (e) {
                    print(e);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error: $e"),
                      ),
                    );
                  }
                },
                child: const Text("Add to favourites"),
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