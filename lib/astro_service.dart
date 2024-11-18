import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class AstroService {
  static const String _apiKey = 'O32VzHDSac'; // Replace with your actual API key
  static const String _secretKey = 'toH48Np5SKGBRZ6mUOoi'; // Replace with your actual secret key
  static const String _baseUrl = 'https://api.xmltime.com/astrodata';

  static Future<String> fetchAstroData({
    required String placeid,
    required String startDate,
    required String endDate,
  }) async {
    try {
      // Step 1: Generate ISO 8601 timestamp in UTC
      final timestamp = DateTime.now().toUtc().toIso8601String().split('.')[0] + 'Z';
      print('Generated ISO 8601 timestamp: $timestamp');

      // Step 2: Build the HMAC string
      final serviceName = 'astrodata';
      final hmacString = '$_apiKey$serviceName$timestamp';
      print('String for HMAC Calculation: $hmacString');

      // Step 3: Generate HMAC-SHA1 signature
      final hmac = Hmac(sha1, utf8.encode(_secretKey));
      final digest = hmac.convert(utf8.encode(hmacString));
      final signature = base64.encode(digest.bytes);
      print('Generated Signature (Base64): $signature');

      // Step 4: Construct the request body (includes both query parameters and operation parameters)
      final requestBody = {
        'accesskey': _apiKey,
        'timestamp': timestamp,
        'version': '3',
        'signature': signature,
        'placeid': placeid,
        'startdt': startDate,
        'enddt': endDate,
      };

      // Log the full request body
      print('Final Request Body: ${jsonEncode(requestBody)}');

      // Step 5: Construct the URL (with no query string this time)
      final url = Uri.parse(_baseUrl);
      print('Final Request URL: $url');

      // Step 6: Send the HTTP POST request
      final client = http.Client();
      try {
        final response = await client.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody),
        );
        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        return response.body;
      } finally {
        client.close();
      }
    } catch (e) {
      print('Error during HTTP Request: $e');
      return '{"version":3,"errors":["$e"]}'; // Return a JSON-like error message
    }
  }
}
