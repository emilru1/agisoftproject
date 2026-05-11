import 'package:flutter/material.dart';
import 'package:group7/api-calls/http_requests.dart';
import 'package:group7/features/current_aqi/aqi_repository.dart';
import 'package:group7/features/current_aqi/aqi_model.dart';
import 'package:group7/features/current_aqi/current_aqi_screen.dart';
import 'package:provider/provider.dart';
import 'package:group7/features/current_aqi/aqi_provider.dart';

class FavouritesPage extends StatefulWidget {
  final String username;

  const FavouritesPage({
    super.key,
    required this.username,
  });

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  List<AqiModel> favourites = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadFavourites();
  }

  Future<void> loadFavourites() async {
    try {
      final users = await ApiService.fetchUsers();

      final user = users.firstWhere(
        (u) => u["username"] == widget.username,
      );

      final userId = user["id"];

      final favs = await ApiService.fetchFavourites(userId);

      final repo = AqiRepository();

      List<AqiModel> loaded = [];

      for (final fav in favs) {
        final lat = double.parse(fav["lat"].toString());
        final lon = double.parse(fav["lon"].toString());

        final aqi = await repo.fetchAqiLatLon(lat, lon);

        loaded.add(aqi);
      }

      setState(() {
        favourites = loaded;
        loading = false;
      });
    } catch (e) {
      print("Error loading favourites: $e");

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.username}'s favourites"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : favourites.isEmpty
              ? const Center(
                  child: Text("No favourites yet"),
                )
              : ListView.builder(
                  itemCount: favourites.length,
                  itemBuilder: (context, index) {
                    final fav = favourites[index];

                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.location_city),

                        title: Text(
                          fav.city,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        subtitle: Text(
                          "AQI: ${fav.general}",
                        ),

                        trailing: const Icon(Icons.arrow_forward_ios),

                        onTap: () async {
                          await context
                              .read<AqiProvider>()
                              .fetchAqiForCoordinates(
                                fav.lat,
                                fav.lon,
                              );

                          if (!context.mounted) return;

                         Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (_) => CurrentAqiScreen(
                              lat: fav.lat,
                              lon: fav.lon,
                            ),
                          ),
                        );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}