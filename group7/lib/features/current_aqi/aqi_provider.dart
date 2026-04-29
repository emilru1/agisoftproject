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
  final bool useMockLocation = true; 

  Future<void> refreshAqi() async {
    _isLoading = true;
    notifyListeners();

    try {
      double? lat;
      double? lon;

      if (useMockLocation) {
        // Hard code values for city to test
        lat = 26.760;
        lon = 83.373;
        
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
      }
      else {
        AqiModel apiData = await _repository.fetchAqiLatLon(lat, lon);
        _currentData = apiData;
      }

    } catch (e) {
      print("Error: $e"); 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  // Function used for search
  Future<void> fetchAqiForCoordinates(double lat, double lon) async {
    _isLoading = true;
    notifyListeners();

    try {
      AqiModel apiData = await _repository.fetchAqiLatLon(lat, lon);
      _currentData = apiData;
    } catch (e) {
      print("Error: $e"); 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}