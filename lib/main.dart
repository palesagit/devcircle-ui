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

// ---------- Topics ----------
class TopicsTab extends StatefulWidget {
  const TopicsTab({super.key});

  @override
  State<TopicsTab> createState() => _TopicsTabState();
}

class _TopicsTabState extends State<TopicsTab> {
  // topic name -> list of messages (starts empty, like Step 3 of the preview)
  final Map<String, List<Message>> _topics = {};

  Future<void> _addTopic() async {
    final result = await askFields(context, 'New topic', ['Topic name']);
    final name = result?.first ?? '';
    if (name.isEmpty) return;
    setState(() => _topics.putIfAbsent(name, () => []));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Topics')),
      body: _topics.isEmpty
          ? const Center(child: Text('No topics yet — start one!'))
          : ListView(
              children: _topics.keys.map((name) {
                return ListTile(
                  leading: const Icon(Icons.tag),
                  title: Text(name),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ChatPage(topic: name, messages: _topics[name]!),
                    ),
                  ),
                );
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTopic,
        child: const Icon(Icons.add),
      ),
    );
  }
}