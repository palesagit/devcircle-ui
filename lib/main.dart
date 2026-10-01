import 'package:flutter/material.dart';

void main() => runApp(const DevCircleApp());

const String currentUser = 'lee_codes';

class DevCircleApp extends StatelessWidget {
  const DevCircleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dev Circle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}