import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'aqi_model.dart'; 

class AqiRepository {

  Future<AqiModel> _fetchAqi(String endpoint) async {
    final apiKey = dotenv.env['WAQI_API_KEY'];
    
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception("API-key missing in .env-file");
    }

    final url = Uri.parse('https://api.waqi.info/feed/$endpoint/?token=$apiKey');

    final response = await http.get(url);


    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == 'ok') {
        return AqiModel.fromJson(jsonResponse);
      } else {
        throw Exception("API-error from server: ${jsonResponse['data']}");
      }
    } else {
      throw Exception("Could not connect. Status code: ${response.statusCode}");
    }
  }

  // Alternativ 1: Hämta via koordinater
  Future<AqiModel> fetchAqiLatLon(double lat, double lon) {
    return _fetchAqi('geo:$lat;$lon');
  }

  // Alternativ 2: Hämta via IP-adress (här)
  Future<AqiModel> fetchAqiHere() {
    return _fetchAqi('here');
  }
  
}