import 'dart:convert';
import 'package:http/http.dart' as http;

class AstroApiClient {
  final String baseUrl = 'https://api.timeanddate.com/astro';
  final String apiKey = 'YOUR_API_KEY'; // Replace with your actual API key

  Future<Map<String, dynamic>> getSunTimes(String location, DateTime date) async {
    final String url = '$baseUrl/sun?location=$location&date=${date.toIso8601String()}&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load Sun times');
    }
  }

  Future<Map<String, dynamic>> getMoonTimes(String location, DateTime date) async {
    final String url = '$baseUrl/moon?location=$location&date=${date.toIso8601String()}&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load Moon times');
    }
  }
}
