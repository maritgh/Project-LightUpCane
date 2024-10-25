import 'package:flutter/material.dart';

void main() {
  runApp(LightupCaneApp());
}

class LightupCaneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'WELKOM BIJ',
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth * 0.12,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'LIGHTUP CANE',
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth * 0.10,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.15),
            Text(
              'De app voor jouw Lightup Cane',
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth * 0.10,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.2),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.1,
                  vertical: screenHeight * 0.02,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondPage()),
                );
              },
              child: Text(
                'Klik hier om verder te gaan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.07,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tweede Pagina'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'kweenie wat hier gaat komen...',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'eerste pagina',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
