// ignore_for_file: unused_field

import 'package:group7/core/widgets/favourite_page.dart';
import 'package:provider/provider.dart';
import 'package:group7/features/current_aqi/aqi_provider.dart';
import 'package:flutter/material.dart';
import 'package:free_map/free_map.dart';
import 'package:group7/theme/app_theme.dart';
import 'package:group7/api-calls/http_requests.dart';

class Navbar extends StatefulWidget implements PreferredSizeWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _NavbarState extends State<Navbar> {
  bool isSearching = false;

  FmData? _address;
  LatLng? _currentPos = LatLng(37.4165849896396, -122.08051867783071); // temp

  final TextEditingController usernameController = TextEditingController();
  bool userCreated = false;

  bool _loading = false;
  bool _isOverlayVisible = false;
  late final MapController _mapController;

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

Future<void> openFavourites() async {
  final username = usernameController.text.trim();

  if (username.isEmpty) return;

  try {
    final exists = await ApiService.checkUserExists(username);

    if (!exists) {
      await ApiService.createUser(username);
    }

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FavouritesPage(username: username),
      ),
    );
  } catch (e) {
    print("Error: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.navBarColor,

      // ---------------------------
      // TITLE AREA (FREE MAP + USER INPUT)
      // ---------------------------
      title: isSearching
          ? searchField
          : Row(
              children: [
                Image.asset(
                  'lib/assets/images/Logo3.png',
                  height: 48,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(width: 12),
                const Text(
                  "AirQualityTracker",
                  style: TextStyle(color: Colors.black),
                ),

                const SizedBox(width: 20),

                // ---------------------------
                // TEST USER INPUT (DATABASE)
                // ---------------------------
                SizedBox(
                  width: 140,
                  height: 40,
                  child: TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      hintText: "username",
                      isDense: true,
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                ElevatedButton(onPressed: openFavourites, child: const Text("Favourites")),

                const SizedBox(width: 8),

                if (userCreated)
                  const Text(
                    "Created ✅",
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
              ],
            ),

      // ---------------------------
      // ACTION BUTTONS
      // ---------------------------
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              isSearching = !isSearching;
            });
          },
          icon: isSearching ? Icon(Icons.close) : Icon(Icons.search),
        ),
        if (!isSearching)
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: Icon(Icons.list),
          ),
      ],
    );
  }

  // ---------------------------
  // FREE MAP SEARCH (UNCHANGED)
  // ---------------------------
  Widget get searchField {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FmSearchField(
        selectedValue: _address,
        onSelected: _onAddressSelected,
        searchParams: const FmSearchParams(),
        resultViewOptions: FmResultViewOptions(
          onOverlayVisible: (v) => setState(() => _isOverlayVisible = v),
        ),
        textFieldBuilder: (focus, controller, onChanged) {
          return TextFormField(
            focusNode: focus,
            onChanged: onChanged,
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              hintText: 'Search',
              fillColor: Colors.grey[300],
              suffixIcon: controller.text.trim().isEmpty || !focus.hasFocus
                  ? null
                  : IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.close),
                      onPressed: controller.clear,
                      visualDensity: VisualDensity.compact,
                    ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------------
  // ADDRESS SELECT
  // ---------------------------
  void _onAddressSelected(FmData? data) {
    if (data == null) return;

    setState(() {
      _address = data;
      _currentPos = LatLng(data.lat, data.lng);
      isSearching = false;
    });

    context.read<AqiProvider>().fetchAqiForCoordinates(data.lat, data.lng);
  }

  Future<void> getGeocode(String address) async {
    final data = await FmService().getGeocode(address: address);
  }
}
