import 'package:flutter/material.dart';
import 'astro_service.dart';

void main() {
  runApp(const AstroDataApp());
}

class AstroDataApp extends StatelessWidget {
  const AstroDataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Astro Data Viewer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AstroDataScreen(),
    );
  }
}

class AstroDataScreen extends StatefulWidget {
  const AstroDataScreen({super.key});

  @override
  State<AstroDataScreen> createState() => _AstroDataScreenState();
}

class _AstroDataScreenState extends State<AstroDataScreen> {
  String _response = "Press the button to fetch Astro data";

  Future<void> _fetchData() async {
    try {
      final data = await AstroService.fetchAstroData(
        placeid: 'norway/oslo', // Replace with a valid placeid
        startDate: DateTime.now().toIso8601String().split('T').first, // Current date
        endDate: DateTime.now().add(const Duration(days: 1)).toIso8601String().split('T').first, // Next day
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
        title: const Text('Astro Data Viewer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _response,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchData,
              child: const Text('Fetch Astro Data'),
            ),
          ],
        ),
      ),
    );
  }
}
