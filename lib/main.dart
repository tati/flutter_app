import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
        'https://api.nasa.gov/planetary/apod?api_key=pxLlMCt0Z8EpcYbTEcdTFSyhsn6sZFledUDEAfyF'); // Replace with the specific endpoint for moon data if available.
       // 'https://api.nasa.gov/planetary/apod?api_key=$apiKey'); // Replace with the specific endpoint for moon data if available.
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
