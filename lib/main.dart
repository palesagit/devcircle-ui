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

// ---------- Reusable dialog with text fields ----------
Future<List<String>?> askFields(
    BuildContext context, String title, List<String> labels) {
  final controllers = labels.map((_) => TextEditingController()).toList();
  return showDialog<List<String>>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < labels.length; i++)
            TextField(
              controller: controllers[i],
              autofocus: i == 0,
              decoration: InputDecoration(labelText: labels[i]),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(
              ctx, controllers.map((c) => c.text.trim()).toList()),
          child: const Text('Save'),
        ),
      ],
    ),
  );
}

// ---------- Home: bottom navigation ----------
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps each tab's data alive when you switch tabs
      body: IndexedStack(
        index: _index,
        children: const [TopicsTab(), ResourcesTab(), MeetingsTab()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.forum), label: 'Topics'),
          NavigationDestination(icon: Icon(Icons.link), label: 'Resources'),
          NavigationDestination(icon: Icon(Icons.event), label: 'Meetings'),
        ],
      ),
    );
  }
}