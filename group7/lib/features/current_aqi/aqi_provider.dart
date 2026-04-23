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
      double? lat;
      double? lon;

      if (useMockLocation) {
        // Hard code values for city to test
        lat = 28.613;
        lon = 77.209;
        
        await Future.delayed(const Duration(seconds: 1)); 

      } else {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            throw Exception("GPS-access denied");
          }
        }
      }

      if(lat == null || lon == null ) {
        AqiModel apiData = await _repository.fetchAqiHere();
        _currentData = apiData;
        print("Called from here");
      }
      else {
        AqiModel apiData = await _repository.fetchAqiLatLon(lat, lon);
        _currentData = apiData;
        print("Called from lat lon");
      }

    } catch (e) {
      print("Error: $e"); 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}