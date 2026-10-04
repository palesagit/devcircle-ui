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

//DATA MODELS
class Message {
  final String sender;
  final String text;
  Message(this.sender, this.text);
}

class Resource {
  final String title;
  final String link;
  Resource(this.title, this.link);
}

class Meeting {
  final String topic;
  final String link;
  final DateTime when;
  Meeting(this.topic, this.link, this.when);
}