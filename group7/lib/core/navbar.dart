import 'package:flutter/material.dart';
import 'package:group7/core/navbar.dart';
import 'package:free_map/free_map.dart';


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
  LatLng? _currentPos;
  bool _loading = false;
  bool _isOverlayVisible = false;
  late final MapController _mapController;
  final _src = const LatLng(37.4165849896396, -122.08051867783071);
  final _dest = const LatLng(37.420921119071586, -122.08535335958004);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.yellow,
      title: isSearching
          ?
          searchField
          : Text(
              "AirQualityTracker",
              style: TextStyle(color: Colors.black),
              
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
         if (!isSearching)IconButton(
          onPressed: () {
            setState(() {
            });
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
    _address = data;
    _currentPos = LatLng(data.lat, data.lng);
    //print(_currentPos);
    //_mapController.move(_currentPos!, 12);
  }
  /// GEOCODING: Get geocode from an address
  Future<void> getGeocode(String address) async {
    final data = await FmService().getGeocode(address: address);
    //print(data);
    //if (kDebugMode) print('${data?.lat},${data?.lng}');
  }
}


