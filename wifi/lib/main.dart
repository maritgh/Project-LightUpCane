import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String esp32Ip = "http://145.24.238.66";

class LedControlApp extends StatefulWidget {
  @override
  _LedControlAppState createState() => _LedControlAppState();
}

class _LedControlAppState extends State<LedControlApp> {
  String _status = "Unknown";
  Timer? _timer;

  // Functie om LED-aanvragen te versturen
  Future<void> toggleLed(String color) async {
    String endpoint;
    if (color == "Blue") {
      endpoint = "/B";
    } else if (color == "Yellow") {
      endpoint = "/Y";
    } else if (color == "Red") {
      endpoint = "/R";
    } else {
      return; // Verlaat de functie als de kleur niet herkend wordt
    }

    final url = Uri.parse("$esp32Ip$endpoint");
    final response = await http.post(url);
    if (response.statusCode == 200) {
      setState(() {
        _status = color;
      });
    } else {
      setState(() {
        _status = "Failed to set color";
      });
    }
  }

  // Functie om huidige LED-status op te halen
  Future<void> getStatus() async {
    final url = Uri.parse("$esp32Ip/status");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _status = response.body; // Verwacht de kleurnaam direct van de ESP32
        });
      } else {
        setState(() {
          _status = "Failed to get status";
        });
      }
    } catch (e) {
      setState(() {
        _status = "Error connecting";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getStatus(); // Haal de initiële status op bij het laden van de app
    _timer = Timer.periodic(Duration(seconds: 5), (timer) => getStatus());
  }

  @override
  void dispose() {
    _timer?.cancel(); // Annuleer de timer bij het sluiten van de widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("LED Control")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Current LED Status: $_status"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => toggleLed("Blue"),
              child: Text("Turn LED Blue"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => toggleLed("Yellow"),
              child: Text("Turn LED Yellow"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => toggleLed("Red"),
              child: Text("Turn LED Red"),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LedControlApp(),
  ));
}
