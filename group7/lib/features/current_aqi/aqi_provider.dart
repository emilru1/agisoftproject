import 'package:flutter/material.dart';
import 'aqi_model.dart';
import 'aqi_repository.dart';
import 'package:geolocator/geolocator.dart';

class AqiProvider with ChangeNotifier {
  final AqiRepository _repository = AqiRepository();
  AqiModel? _currentData;
  bool _isLoading = false;

  AqiModel? get currentData => _currentData;
  bool get isLoading => _isLoading;

  // Set true to test functionality with mock data
  final bool useMockLocation = false; 

  Future<void> refreshAqi() async {
    _isLoading = true;
    notifyListeners();

    try {
      double lat;
      double lon;

      if (useMockLocation) {
        // Hard code values for city to test
        lat = 28.613;
        lon = 77.209;
        
        await Future.delayed(const Duration(seconds: 1)); 

      } else {
        print("Step 1: Check permission...");
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            throw Exception("GPS-access denied");
          }
        }

        /*

        Works bad when using web, use mock data instead

        */

        print("Step 2: Fetch GPS-position...");
  
        Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low, 
        ).timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            throw Exception("GPS-search took to much time (Timeout)");
          },
        );
        lat = pos.latitude;
        lon = pos.longitude;

        print("Koordinater hittade: $lat, $lon");
      }

      print("Step 3: Fetch air quality from repository...");
      AqiModel apiData = await _repository.fetchAqi(lat, lon);

      _currentData = apiData;
      
      print("Step 4: Ok! City founded API: ${_currentData?.city}");

    } catch (e) {
      print("Error: $e"); 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}