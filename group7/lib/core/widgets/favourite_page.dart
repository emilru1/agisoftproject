import 'package:flutter/material.dart';
import 'package:group7/api-calls/http_requests.dart';

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
  List<dynamic> favourites = [];
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

      setState(() {
        favourites = favs
            .where((f) => f["username"] == widget.username)
            .toList();

        loading = false;
      });
    } catch (e) {
      print(e);

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

                    return ListTile(
                      leading: const Icon(Icons.favorite),
                      title: Text(
                        "Lat: ${fav["lat"]}",
                      ),
                      subtitle: Text(
                        "Lon: ${fav["lon"]}",
                      ),
                    );
                  },
                ),
    );
  }
}