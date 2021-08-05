import 'package:flutter/material.dart';
import 'package:sparkler/canvas.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sparkler',
      home: Scaffold(
        body: Canvas(),
      ),
    );
  }
}
