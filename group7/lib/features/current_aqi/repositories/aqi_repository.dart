import '../models/aqi_model.dart';

class AqiRepository {
  // Vi struntar i HTTP och API-nycklar för tillfället!

  Future<AqiModel> fetchAqi(double lat, double lon) async {
    // 1. Låtsas att vi väntar på svar från internet i 2 sekunder
    await Future.delayed(const Duration(seconds: 2));

    // 2. Skicka tillbaka fejkad data
    return AqiModel(
      aqi: 400, 
      city: "", // Denna skrivs ändå över av din Provider via GPS!
      timestamp: DateTime.now(),
    );
  }
}