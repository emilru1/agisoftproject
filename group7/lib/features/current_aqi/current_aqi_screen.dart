import 'package:flutter/material.dart';
import 'package:group7/api-calls/http_requests.dart';
import 'package:group7/core/dataDisplay.dart';
import 'package:provider/provider.dart';
import 'aqi_provider.dart';
import 'package:group7/core/widgets/pollutantText.dart';
import 'package:group7/core/navbar.dart';
import 'package:group7/features/user/user_provider.dart';
import 'aqi_forecast_widget.dart';
import 'package:group7/theme/app_theme.dart';

class CurrentAqiScreen extends StatefulWidget {
  final double? lat;
  final double? lon;

  const CurrentAqiScreen({super.key, this.lat, this.lon});

  @override
  State<CurrentAqiScreen> createState() => _CurrentAqiScreenState();
}

class _CurrentAqiScreenState extends State<CurrentAqiScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (widget.lat != null && widget.lon != null) {
        await context.read<AqiProvider>().fetchAqiForCoordinates(
          widget.lat!,
          widget.lon!,
        );
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
      extendBodyBehindAppBar: true,
      appBar: Navbar(activePage: 'home'),
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
          child: SingleChildScrollView(
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isWideEnough = constraints.maxWidth > 1200;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.city,
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontSize: 32,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (isWideEnough)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Datadisplay(),
                              IconButton(
                                icon: const Icon(
                                  Icons.refresh,
                                  color: AppTheme.white,
                                  size: 40,
                                ),
                                onPressed: () => aqiProvider.refreshAqi(),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.favorite_border_rounded,
                                  color: Colors.white,
                                  size: 26,
                                ),
                                tooltip: "Add to favourites",
                                onPressed: () async {
                                  final username = context
                                      .read<UserProvider>()
                                      .username;

                                  if (username == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("No user selected"),
                                      ),
                                    );
                                    return;
                                  }

                                  try {
                                    final result =
                                        await ApiService.createFavourite(
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
                                      SnackBar(content: Text("Error: $e")),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          SizedBox(width: 80),
                          AqiForecastWidget(
                            forecastData: data.threeDayForecast,
                          ),
                        ],
                      )
                    else
                      Column(
                        children: [
                          Datadisplay(),
                          IconButton(
                            icon: const Icon(
                              Icons.refresh,
                              color: AppTheme.white,
                              size: 40,
                            ),
                            onPressed: () => aqiProvider.refreshAqi(),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.favorite_border_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                            tooltip: "Add to favourites",
                            onPressed: () async {
                              final username = context
                                  .read<UserProvider>()
                                  .username;

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
                                  SnackBar(content: Text("Error: $e")),
                                );
                              }
                            },
                          ),
                          SizedBox(height: 24),

                          AqiForecastWidget(
                            forecastData: data.threeDayForecast,
                          ),
                        ],
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}