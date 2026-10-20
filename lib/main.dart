import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'shell_widgets.dart'; 
import 'theme.dart'; 

void main() => runApp(const DevCircleApp());

// no fake user. This prototype has no login, so everyone is a guest.
const String currentUser = 'guest';

class DevCircleApp extends StatelessWidget {
  const DevCircleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevCircle',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(), 
      home: const HomePage(),
    );
  }
}

// ---------- DATA MODELS ----------
class Message {
  final String sender;
  final String text;
  Message(this.sender, this.text);
}

//a topic now keeps its own messages and an unread counter
class Topic {
  final String name;
  final List<Message> messages;
  int unread;
  Topic(this.name, {List<Message>? messages, this.unread = 0})
      : messages = messages ?? [];
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

//a "circle" is one community (DevCircle, Java, Python, Flutter...)
class Circle {
  final String name;
  final String tag; // 2 letters shown in the left strip
  final String subtitle;
  final List<Topic> topics;
  final List<Resource> resources;
  final List<Meeting> meetings;
  Circle(
    this.name,
    this.tag, {
    this.subtitle = 'Software engineering students',
    List<Topic>? topics,
    List<Resource>? resources,
    List<Meeting>? meetings,
  })  : topics = topics ?? [],
        resources = resources ?? [],
        meetings = meetings ?? [];
}

// the app now starts EMPTY 
// or other circles. Everything you see is created by the user.
List<Circle> startingCircles() => [Circle('DevCircle', 'DC')];

// ---------- helpers ----------
const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];

String shortWhen(DateTime d) {
  final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final ampm = d.hour >= 12 ? 'PM' : 'AM';
  final min = d.minute == 0 ? '' : ':${d.minute.toString().padLeft(2, '0')}';
  final soon = d.difference(DateTime.now()).inDays < 7;
  final day = soon ? _weekdays[d.weekday - 1] : '${_months[d.month - 1]} ${d.day}';
  return '$day $h$min $ampm';
}

// Copy a link and show a message at the bottom of the screen
Future<void> copyLink(BuildContext context, String link) async {
  await Clipboard.setData(ClipboardData(text: link));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Link copied to clipboard')),
  );
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

// small details dialog for a resource or a meeting
Future<void> showDetails(
    BuildContext context, String title, String details, String link) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(link.isEmpty ? details : '$details\n$link'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        if (link.isNotEmpty)
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              copyLink(context, link);
            },
            child: const Text('Copy link'),
          ),
      ],
    ),
  );
}

// ---------- Home: server strip + sidebar (+ chat on wide screens) ----------
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Circle> _circles = startingCircles();
  int _selected = 0;
  Topic? _openTopic; // only used on wide screens (web / desktop / tablet)

  Circle get _circle => _circles[_selected];

  void _snack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _addCircle() async {
    final r = await askFields(context, 'New circle', ['Circle name']);
    if (r == null || r.first.isEmpty) return;
    setState(() {
      _circles.add(Circle(r.first, initialsOf(r.first)));
      _selected = _circles.length - 1;
      _openTopic = null;
    });
  }

  Future<void> _addTopic() async {
    final r = await askFields(context, 'New topic', ['Topic name']);
    final name = r?.first ?? '';
    if (name.isEmpty) return;
    if (_circle.topics.any((t) => t.name == name)) {
      if (!mounted) return;
      _snack('That topic already exists');
      return;
    }
    setState(() => _circle.topics.add(Topic(name)));
  }

  Future<void> _addResource() async {
    final r = await askFields(context, 'Share a resource', ['Title', 'Link']);
    if (r == null || r[0].isEmpty || r[1].isEmpty) return;
    setState(() => _circle.resources.add(Resource(r[0], r[1])));
  }

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
      _circle.meetings.add(Meeting(r[0], r[1], when));
      _circle.meetings.sort((a, b) => a.when.compareTo(b.when)); // soonest first
    });
  }

  void _openChat(Topic t, bool wide) {
    setState(() {
      t.unread = 0; // reading a topic clears its badge
      if (wide) _openTopic = t;
    });
    if (!wide) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ChatPage(topic: t)),
      ).then((_) {
        if (mounted) setState(() {}); // refresh after coming back
      });
    }
  }

  Widget _buildSidebar(bool wide) {
    final c = _circle;
    return Container(
      color: AppColors.sidebar,
      child: Column(
        children: [
          SidebarHeader(title: c.name, subtitle: c.subtitle),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 12),
              children: [
                SectionHeader('TOPICS',
                    onAdd: _addTopic, addKey: const Key('add-topic')),
                if (c.topics.isEmpty) const EmptyHint('No topics yet'),
                for (final t in c.topics)
                  SidebarRow(
                    leading: const HashLeading(),
                    label: t.name,
                    bold: t.unread > 0,
                    selected: wide && _openTopic == t,
                    trailing: t.unread > 0 ? UnreadBadge(t.unread) : null,
                    onTap: () => _openChat(t, wide),
                  ),
                SectionHeader('RESOURCES',
                    onAdd: _addResource, addKey: const Key('add-resource')),
                if (c.resources.isEmpty) const EmptyHint('No resources yet'),
                for (final r in c.resources)
                  SidebarRow(
                    leading: const Icon(Icons.link,
                        size: 18, color: AppColors.muted),
                    label: r.title,
                    onTap: () => showDetails(context, r.title, 'Shared resource', r.link),
                  ),
                SectionHeader('MEETINGS',
                    onAdd: _addMeeting, addKey: const Key('add-meeting')),
                if (c.meetings.isEmpty) const EmptyHint('No meetings scheduled'),
                for (final m in c.meetings)
                  SidebarRow(
                    leading: const Icon(Icons.event_outlined,
                        size: 18, color: AppColors.muted),
                    label: m.topic,
                    trailing: Text(shortWhen(m.when),
                        style: const TextStyle(
                            color: AppColors.muted, fontSize: 12)),
                    onTap: () => showDetails(
                        context, m.topic, shortWhen(m.when), m.link),
                  ),
              ],
            ),
          ),
          UserFooter(
            username: currentUser,
            subtitle: 'Prototype - no login',
            action: IconButton(
              tooltip: 'Settings',
              icon: const Icon(Icons.tune, color: AppColors.muted),
              // Real settings (password reset, log out) live in devcircle-auth
              onPressed: () => _snack('Settings are in the devcircle-auth app'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.rail,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          // ADDED: on wide screens the chat opens next to the sidebar
          final wide = constraints.maxWidth >= 700;
          return Row(
            children: [
              ServerRail(
                tags: _circles.map((c) => c.tag).toList(),
                selected: _selected,
                onSelect: (i) => setState(() {
                  _selected = i;
                  _openTopic = null;
                }),
                onAdd: _addCircle,
              ),
              if (wide)
                SizedBox(width: 300, child: _buildSidebar(true))
              else
                Expanded(child: _buildSidebar(false)),
              if (wide)
                Expanded(
                  child: Container(
                    color: AppColors.chatBg,
                    child: _openTopic == null
                        ? const Center(
                            child: Text('Pick a topic to start chatting',
                                style: TextStyle(color: AppColors.muted)))
                        : Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: AppColors.divider)),
                                ),
                                child: Text('# ${_openTopic!.name}',
                                    style: const TextStyle(
                                        color: AppColors.text,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Expanded(
                                  child: ChatView(
                                      key: ValueKey(_openTopic),
                                      topic: _openTopic!)),
                            ],
                          ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

// ---------- Chat ----------
// the old ChatPage is now split in two: ChatPage (phone screen with
// an app bar) and ChatView (the messages + input, reused on wide screens).
class ChatPage extends StatelessWidget {
  final Topic topic;
  const ChatPage({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('# ${topic.name}')),
      body: ChatView(topic: topic),
    );
  }
}

class ChatView extends StatefulWidget {
  final Topic topic;
  const ChatView({super.key, required this.topic});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _controller = TextEditingController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => widget.topic.messages.add(Message(currentUser, text)));
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = widget.topic.messages;
    return Column(
      children: [
        Expanded(
          child: messages.isEmpty
              ? const Center(
                  child: Text('No messages yet — say hi!',
                      style: TextStyle(color: AppColors.muted)))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    final m = messages[i];
                    final mine = m.sender == currentUser;
                    return Align(
                      alignment:
                          mine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(10),
                        constraints: const BoxConstraints(maxWidth: 280),
                        decoration: BoxDecoration(
                          color: mine ? AppColors.brand : AppColors.selected,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m.sender,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: mine
                                        ? Colors.white70
                                        : AppColors.accent)),
                            Text(m.text,
                                style:
                                    const TextStyle(color: AppColors.text)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _send(),
                    decoration: InputDecoration(
                      hintText: 'Message #${widget.topic.name}',
                      filled: true,
                      fillColor: AppColors.selected,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _send,
                  icon: const Icon(Icons.send, color: AppColors.accent),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
