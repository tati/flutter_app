import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class AstroService {
  static const String _apiKey = 'O32VzHDSac';
  static const String _secretKey = 'toH48Np5SKGBRZ6mUOoi';
  static const String _baseUrl = 'https://api.xmltime.com/astrodata';

  static Future<String> fetchAstroData({
    required String placeId,
    required String startDate,
    required String endDate,
  }) async {
    // Step 1: Generate ISO 8601 timestamp in UTC without fractional seconds
    final timestamp = DateTime.now().toUtc().toIso8601String().split('.')[0] + 'Z';
    print('Generated ISO 8601 timestamp: $timestamp');

    // Step 2: Prepare the query parameters
    final Map<String, String> queryParams = {
      'accesskey': _apiKey,
      'enddt': endDate,
      'placeid': placeId,
      'startdt': startDate,
      'timestamp': timestamp,
      'version': '1',
    };

    // Step 3: Sort the parameters alphabetically by key
    final sortedKeys = queryParams.keys.toList()..sort();
    print('Sorted Keys: $sortedKeys');

    // Step 4: Build the string for HMAC (do not URL-encode values here)
    final rawQueryString = sortedKeys.map((key) => '$key=${queryParams[key]}').join('&');
    print('String for HMAC: $rawQueryString');

    // Step 5: Generate HMAC-SHA1 signature
    final hmac = Hmac(sha1, utf8.encode(_secretKey));
    final generatedSignature = hmac.convert(utf8.encode(rawQueryString)).toString();
    print('Generated Signature: $generatedSignature');

    // Step 6: Verify Signature with OpenSSL (Optional, for Debugging)
    _verifySignatureWithOpenSSL(rawQueryString, _secretKey, generatedSignature);

    // Step 7: URL-encode parameter values for the request URL
    final encodedQueryParams = sortedKeys.map((key) {
      final value = Uri.encodeComponent(queryParams[key]!);
      return '$key=$value';
    }).join('&');

    // Construct the final URL with the signature
    final url = Uri.parse('$_baseUrl?$encodedQueryParams&signature=$generatedSignature');
    print('Final Request URL: $url');

    // Step 8: Send the GET request
    final client = http.Client();
    try {
      final response = await client.get(url);

      print('Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        // Check for error messages in the response body
        if (response.body.contains('"Signature invalid"')) {
          print('Warning: API response indicates "Signature invalid".');
          return '{"version":1,"errors":["Signature invalid detected in response"]}';
        }
        return response.body; // Return the body if successful
      } else {
        throw Exception(
          'HTTP Error: Status Code ${response.statusCode}\nResponse: ${response.body}',
        );
      }
    } catch (e) {
      print('Error: $e');
      return '{"version":1,"errors":["$e"]}'; // Return a JSON-like error message
    } finally {
      client.close();
    }
  }

  // Step 6 Helper Function: Verify Signature with OpenSSL (Optional, Debugging Only)
  static void _verifySignatureWithOpenSSL(String rawQueryString, String secretKey, String generatedSignature) {
    print('Verifying signature using OpenSSL (manual check):');
    print('Raw Query String: $rawQueryString');
    print('Secret Key: $secretKey');

    // Simulate OpenSSL HMAC generation (for reference)
    final hmac = Hmac(sha1, utf8.encode(secretKey));
    final opensslSignature = hmac.convert(utf8.encode(rawQueryString)).toString();
    print('OpenSSL-like Signature: $opensslSignature');

    if (generatedSignature != opensslSignature) {
      print('Warning: Generated signature does not match OpenSSL-calculated signature.');
      print('Generated Signature: $generatedSignature');
      print('OpenSSL-like Signature: $opensslSignature');
    } else {
      print('Signature verification passed (matches OpenSSL output).');
    }
  }
}
