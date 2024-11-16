import 'package:flutter/material.dart';
import 'astro_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time and Date API Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AstroDataScreen(),
    );
  }
}

class AstroDataScreen extends StatefulWidget {
  @override
  _AstroDataScreenState createState() => _AstroDataScreenState();
}

class _AstroDataScreenState extends State<AstroDataScreen> {
  String _response = "Press the button to fetch Astro data";

  Future<void> _fetchData() async {
    try {
      final data = await AstroService.fetchAstroData(
        placeId: 'norway/oslo',
        startDate: DateTime.now().toIso8601String().split('T').first,
        endDate: DateTime.now().add(Duration(days: 1)).toIso8601String().split('T').first,
      );
      setState(() {
        _response = data;
      });
    } catch (e) {
      setState(() {
        _response = "Error: $e";
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Astro Data Viewer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _response,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _fetchData,
              child: Text('Fetch Astro Data'),
            ),
          ],
        ),
      ),
    );
  }
}
