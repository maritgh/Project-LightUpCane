import 'package:flutter/material.dart';

class DisplayPage extends StatelessWidget{  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display Page')),
      body: Center(child: Text('Welcome to the Display Page!')),
    );
  }
}