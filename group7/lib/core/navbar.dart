// ignore_for_file: unused_field
import 'package:group7/features/current_aqi/current_aqi_screen.dart';
import 'package:group7/features/help/help_page.dart';
import 'package:provider/provider.dart';
import 'package:group7/features/current_aqi/aqi_provider.dart';

import 'package:flutter/material.dart';
import 'package:free_map/free_map.dart';
import 'package:group7/theme/app_theme.dart';

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

  bool _loading = false;
  bool _isOverlayVisible = false;
  late final MapController _mapController;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.navBarColor,
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
                Expanded(
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            textStyle: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CurrentAqiScreen(),
                              ),
                            );
                          },
                          child: const Text("Home"),
                        ),
                        const SizedBox(
                          height: 32,
                          child: VerticalDivider(
                            color: Colors.black54,
                            thickness: 1,
                            width: 24,
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            textStyle: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HelpPage(),
                              ),
                            );
                          },
                          child: const Text("Learn"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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

  //  _address!.address.toString() To get the location
  void _onAddressSelected(FmData? data) {
    if (data == null) return;

    // Uppdate if lat/lon is provided
    setState(() {
      _address = data;
      _currentPos = LatLng(data.lat, data.lng);
      isSearching = false;
    });

    // Send data to aqi_provider
    context.read<AqiProvider>().fetchAqiForCoordinates(data.lat, data.lng);
  }

  Future<void> getGeocode(String address) async {
    final data = await FmService().getGeocode(address: address);
  }
}
