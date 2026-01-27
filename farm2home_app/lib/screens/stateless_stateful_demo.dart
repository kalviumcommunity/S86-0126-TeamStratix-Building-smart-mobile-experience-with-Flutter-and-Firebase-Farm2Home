import 'package:flutter/material.dart';

/// Stateless widget: displays a static header
class DemoHeader extends StatelessWidget {
  final String title;
  const DemoHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Stateful widget: interactive counter
class DemoCounter extends StatefulWidget {
  const DemoCounter({super.key});

  @override
  State<DemoCounter> createState() => _DemoCounterState();
}

class _DemoCounterState extends State<DemoCounter> {
  int count = 0;
  bool isDark = false;

  void increment() {
    setState(() {
      count++;
    });
  }

  void toggleTheme() {
    setState(() {
      isDark = !isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Counter: $count',
            style: TextStyle(
              fontSize: 22,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: increment,
            child: const Text('Increase'),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text(isDark ? 'Dark Mode' : 'Light Mode'),
            value: isDark,
            onChanged: (val) => toggleTheme(),
          ),
        ],
      ),
    );
  }
}

/// Demo screen combining both widgets
class StatelessStatefulDemoScreen extends StatelessWidget {
  const StatelessStatefulDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stateless vs Stateful Demo'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            DemoHeader(title: 'Interactive Counter App'),
            SizedBox(height: 24),
            DemoCounter(),
          ],
        ),
      ),
    );
  }
}
