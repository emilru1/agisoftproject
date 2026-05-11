import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  static Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse("$baseUrl/fetchusers/"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch users");
    }
  }

  static Future<Map<String, dynamic>> createUser(String username) async {
    final url = Uri.parse(
      "$baseUrl/createuser/?username=$username",
    );

    print(url);

    final response = await http.get(url);

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to create user");
    }
  }

  static Future<List<dynamic>> fetchFavourites(int userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/fetchfavourites/?userid=$userId"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch favourites");
    }
  }

  static Future<bool> checkUserExists(String username) async {
    final response = await http.get(
      Uri.parse("$baseUrl/checkuser/?username=$username"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["exists"];
    } else {
      throw Exception("Failed to check user");
    }
  }

  static Future<Map<String, dynamic>> createFavourite({
    required String username,
    required String lat,
    required String lon,
  }) async {
    final response = await http.get(
      Uri.parse(
        "$baseUrl/createfavourite/?username=$username&lat=$lat&lon=$lon",
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to create favourite");
    }
  }
}
