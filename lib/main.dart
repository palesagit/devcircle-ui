import 'package:flutter/material.dart';

void main() => runApp(const DevCircleApp());

const String currentUser = 'lee_codes';

class DevCircleApp extends StatelessWidget {
  const DevCircleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevCircle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8E5FC1)),
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

// ---------- Chat ----------
class ChatPage extends StatefulWidget {
  final String topic;
  final List<Message> messages;
  const ChatPage({super.key, required this.topic, required this.messages});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => widget.messages.add(Message(currentUser, text)));
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.topic)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: widget.messages.length,
              itemBuilder: (context, i) {
                final m = widget.messages[i];
                final mine = m.sender == currentUser;
                return Align(
                  alignment:
                      mine ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(10),
                    constraints: const BoxConstraints(maxWidth: 260),
                    decoration: BoxDecoration(
                      color: mine
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.sender,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: mine ? Colors.white70 : Colors.black54)),
                        Text(m.text,
                            style: TextStyle(
                                color: mine ? Colors.white : Colors.black87)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(
                        hintText: 'Ask a question...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(onPressed: _send, icon: const Icon(Icons.send)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- Resources ----------
class ResourcesTab extends StatefulWidget {
  const ResourcesTab({super.key});

  @override
  State<ResourcesTab> createState() => _ResourcesTabState();
}

class _ResourcesTabState extends State<ResourcesTab> {
  final List<Resource> _resources = [
    Resource('Big-O Cheat Sheet', 'bigocheatsheet.com'),
    Resource('Dart Language Tour', 'dart.dev/language'),
  ];

  Future<void> _addResource() async {
    final r = await askFields(context, 'Share a resource', ['Title', 'Link']);
    if (r == null || r[0].isEmpty || r[1].isEmpty) return;
    setState(() => _resources.add(Resource(r[0], r[1])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resources')),
      body: ListView(
        children: _resources
            .map((r) => ListTile(
                  leading: const Icon(Icons.link),
                  title: Text(r.title),
                  subtitle: Text(r.link),
                ))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addResource,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ---------- Meetings ----------
class MeetingsTab extends StatefulWidget {
  const MeetingsTab({super.key});

  @override
  State<MeetingsTab> createState() => _MeetingsTabState();
}

class _MeetingsTabState extends State<MeetingsTab> {
  final List<Meeting> _meetings = [];
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  Future<void> _addMeeting() async {
    final r =
        await askFields(context, 'New meeting', ['Topic', 'Meeting link']);
    if (r == null || r[0].isEmpty) return;
    if (!mounted) return; // context is used after an await

    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;

    final time =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time == null) return;

    final when =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      _meetings.add(Meeting(r[0], r[1], when));
      _meetings.sort((a, b) => a.when.compareTo(b.when)); // soonest first
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meetings')),
      body: _meetings.isEmpty
          ? const Center(child: Text('No meetings scheduled.'))
          : ListView(
              children: _meetings.map((m) {
                final t = TimeOfDay.fromDateTime(m.when).format(context);
                return ListTile(
                  leading: const Icon(Icons.event),
                  title: Text(m.topic),
                  subtitle:
                      Text('${_months[m.when.month - 1]} ${m.when.day} • $t'),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                );
              }).toList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMeeting,
        child: const Icon(Icons.add),
      ),
    );
  }
}
