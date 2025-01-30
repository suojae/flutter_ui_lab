import 'package:flutter/material.dart';

import '2025/01/30.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        backgroundColor: Color(0xFFF7EFE5),
        body: SafeArea(
          child: Center(
            child: AnimatedBlob(
              startColor: Color(0xFFF05A7E),
              endColor: Color(0xFFFFBE98),
              gradientDirection: Alignment.topLeft,
            ),
          ),
        ),
      ),
    );
  }
}
