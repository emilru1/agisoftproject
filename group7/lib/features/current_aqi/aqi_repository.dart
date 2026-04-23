import 'aqi_model.dart';

class AqiRepository {

  /*

  No HTTP or APi_keys yet! Implement later.

  */

  Future<AqiModel> fetchAqi(double lat, double lon) async {
    await Future.delayed(const Duration(seconds: 2)); // Fake a wating time of 2s

    // Return fake data¨
    
    return AqiModel(
      aqi: 60, 
      city: "", timestamp: 
      DateTime.now()
    );
  }

}