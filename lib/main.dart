import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'services/api_client.dart';

class AstroPage extends StatefulWidget {
  @override
  _AstroPageState createState() => _AstroPageState();
}

class _AstroPageState extends State<AstroPage> {
  final AstroApiClient _astroApiClient = AstroApiClient();
  Map<String, dynamic>? sunTimes;
  Map<String, dynamic>? moonTimes;

  @override
  void initState() {
    super.initState();
    fetchAstroData();
  }

  Future<void> fetchAstroData() async {
    try {
      final String location = 'newyork'; // Specify your location here
      final DateTime date = DateTime.now();
      final sunData = await _astroApiClient.getSunTimes(location, date);
      final moonData = await _astroApiClient.getMoonTimes(location, date);

      setState(() {
        sunTimes = sunData;
        moonTimes = moonData;
      });
    } catch (e) {
      print('Error fetching astro data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Astronomical Data'),
      ),
      body: sunTimes == null || moonTimes == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sunrise: ${sunTimes?['results']['sunrise'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Sunset: ${sunTimes?['results']['sunset'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Moonrise: ${moonTimes?['results']['moonrise'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Moonset: ${moonTimes?['results']['moonset'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
    );
  }
}






void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NASA Moon Phase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MoonPhaseScreen(),
    );
  }
}

class MoonPhaseScreen extends StatefulWidget {
  @override
  _MoonPhaseScreenState createState() => _MoonPhaseScreenState();
}

class _MoonPhaseScreenState extends State<MoonPhaseScreen> {
  String apiKey = 'YOUR_NASA_API_KEY';
  Map<String, dynamic>? moonPhaseData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMoonPhaseData();
  }

  Future<void> fetchMoonPhaseData() async {
    final url = Uri.parse(
        'https://api.xmltime.com/astronomy?api_key=M27xtssPLv'); // pull moon phase data
       // 'https://api.nasa.gov/planetary/apod?api_key=pxLlMCt0Z8EpcYbTEcdTFSyhsn6sZFledUDEAfyF'); // Replace with the specific endpoint for moon data if available.
    //https://dev.timeanddate.com/docs/astro/
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          moonPhaseData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load moon phase data');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moon Phase Data'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : moonPhaseData != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Title: ${moonPhaseData!['title'] ?? 'No title'}',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Explanation: ${moonPhaseData!['explanation'] ?? 'No explanation available'}',
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Text(
                    'Failed to load moon phase data',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                ),
    );
  }
}
