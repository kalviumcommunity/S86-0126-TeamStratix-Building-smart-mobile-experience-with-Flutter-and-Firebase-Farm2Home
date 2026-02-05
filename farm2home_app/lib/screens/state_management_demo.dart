import 'package:flutter/material.dart';

/// Demonstrates local UI state management using setState()
/// 
/// This screen shows how Flutter manages state in Stateful widgets
/// by implementing a simple counter with increment/decrement functionality.
/// The UI updates dynamically in response to user interactions.
class StateManagementDemo extends StatefulWidget {
  const StateManagementDemo({super.key});

  @override
  State<StateManagementDemo> createState() => _StateManagementDemoState();
}

class _StateManagementDemoState extends State<StateManagementDemo> {
  // Local state variable - tracks the counter value
  int _counter = 0;

  /// Increments the counter and updates UI
  /// setState() notifies Flutter to rebuild the widget with new data
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  /// Decrements the counter and updates UI
  /// Includes validation to prevent negative values
  void _decrementCounter() {
    setState(() {
      if (_counter > 0) _counter--;
    });
  }

  /// Resets the counter back to zero
  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('State Management Demo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      // Conditional background color based on counter value
      // Demonstrates data-driven UI updates
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _counter >= 10
                ? [Colors.green.shade100, Colors.green.shade300]
                : _counter >= 5
                    ? [Colors.blue.shade100, Colors.blue.shade300]
                    : [Colors.grey.shade100, Colors.grey.shade200],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Info section
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Button pressed:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Counter display with dynamic styling
                    Text(
                      '$_counter',
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: _counter >= 10
                            ? Colors.green.shade700
                            : _counter >= 5
                                ? Colors.blue.shade700
                                : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _counter == 1 ? 'time' : 'times',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Status message based on counter value
                    _buildStatusMessage(),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Decrement button
                  ElevatedButton.icon(
                    onPressed: _counter > 0 ? _decrementCounter : null,
                    icon: const Icon(Icons.remove),
                    label: const Text('Decrement'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Increment button
                  ElevatedButton.icon(
                    onPressed: _incrementCounter,
                    icon: const Icon(Icons.add),
                    label: const Text('Increment'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Reset button
              OutlinedButton.icon(
                onPressed: _counter > 0 ? _resetCounter : null,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  foregroundColor: Colors.grey.shade700,
                  side: BorderSide(color: Colors.grey.shade400),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Educational info card
              _buildInfoCard(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds status message widget based on counter value
  Widget _buildStatusMessage() {
    String message;
    IconData icon;
    Color color;

    if (_counter >= 10) {
      message = '🎉 Excellent! You\'re on fire!';
      icon = Icons.whatshot;
      color = Colors.green.shade700;
    } else if (_counter >= 5) {
      message = '👍 Great job! Keep going!';
      icon = Icons.thumb_up;
      color = Colors.blue.shade700;
    } else if (_counter > 0) {
      message = '✨ Good start!';
      icon = Icons.star;
      color = Colors.orange.shade700;
    } else {
      message = 'Press a button to start';
      icon = Icons.touch_app;
      color = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            message,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds educational info card explaining setState()
  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                'How setState() Works',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            '• setState() notifies Flutter that state has changed\n'
            '• Flutter rebuilds only affected widgets\n'
            '• Background color changes based on counter value\n'
            '• Buttons enable/disable based on conditions',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
