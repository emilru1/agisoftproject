import 'package:flutter/material.dart';
import 'aqi_model.dart';
import 'aqi_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; 

class AqiProvider with ChangeNotifier {
  final AqiRepository _repository = AqiRepository();
  AqiModel? _currentData;
  bool _isLoading = false;

  AqiModel? get currentData => _currentData;
  bool get isLoading => _isLoading;

  // Set true to test functionality with mock data
  final bool useMockLocation = true; 

  Future<void> refreshAqi() async {
    _isLoading = true;
    notifyListeners();

    try {
      double lat;
      double lon;
      String currentCity;

      if (useMockLocation) {
        // Hard coded for San Francisco
        lat = 37.757;
        lon = -122.449;
        currentCity = "San Francisco";
        
        await Future.delayed(const Duration(seconds: 1)); 

      } else {
        print("Step 1: Check permission...");
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            throw Exception("GPS-acces denied");
          }
        }

        print("Step 2: Fetch GPS-position...");
        Position pos = await Geolocator.getCurrentPosition(
          timeLimit: const Duration(seconds: 1),
        );
        lat = pos.latitude;
        lon = pos.longitude;

        print(pos);

        print("Step 3: Translate GPS to city name");
        List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
        currentCity = placemarks.first.locality ?? "Unknowed City";
      }

      // Either mock data or real data
      print("Step 4: Fetch air quality from repository...");
      AqiModel apiData = await _repository.fetchAqi(lat, lon);

      // Create updated model
      _currentData = AqiModel(
        aqi: apiData.aqi,
        city: currentCity,
        timestamp: DateTime.now(),
      );
      
      print("Step 5: Ok!");

    } catch (e) {
      print("Error: $e"); 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}