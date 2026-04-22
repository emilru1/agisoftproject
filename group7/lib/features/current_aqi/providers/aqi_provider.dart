import 'package:flutter/material.dart';
import '../models/aqi_model.dart';
import '../repositories/aqi_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; 

class AqiProvider with ChangeNotifier {
  final AqiRepository _repository = AqiRepository();
  AqiModel? _currentData;
  bool _isLoading = false;

  AqiModel? get currentData => _currentData;
  bool get isLoading => _isLoading;

  Future<void> refreshAqi() async {
    _isLoading = true;
    notifyListeners();

    try {
      print("Steg 1: Kollar behörigheter...");
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("GPS-behörighet nekad");
        }
      }

      print("Steg 2: Hämtar GPS-position (Här fastnar ofta emulatorer!)...");
      // Vi lägger till en timeout på 5 sekunder, så den inte snurrar för evigt!
      Position pos = await Geolocator.getCurrentPosition(
        timeLimit: const Duration(seconds: 5),
      );

      print("Steg 3: Översätter GPS till stadsnamn...");
      List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      String currentCity = placemarks.first.locality ?? "Okänd ort";

      print("Steg 4: Hämtar luftkvalitet från Repository...");
      AqiModel apiData = await _repository.fetchAqi(pos.latitude, pos.longitude);

      _currentData = AqiModel(
        aqi: apiData.aqi,
        city: currentCity,
        timestamp: DateTime.now(),
      );
      
      print("Steg 5: Allt gick bra!");

    } catch (e) {
      print("FEL UPPTÄCKT: $e"); // Om den kraschar hamnar vi här
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 