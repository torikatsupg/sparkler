import 'package:flutter/material.dart';
import 'package:sparkler/ui/canvas.dart';

class App extends StatelessWidget {
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
