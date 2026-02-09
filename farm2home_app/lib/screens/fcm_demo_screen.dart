import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/notification_service.dart';

/// FCM Demo Screen
/// Demonstrates Firebase Cloud Messaging integration and notification handling
class FCMDemoScreen extends StatefulWidget {
  const FCMDemoScreen({super.key});

  @override
  State<FCMDemoScreen> createState() => _FCMDemoScreenState();
}

class _FCMDemoScreenState extends State<FCMDemoScreen>
    with WidgetsBindingObserver {
  late NotificationService _notificationService;
  String _fcmToken = 'Loading...';
  bool _initialized = false;
  AppLifecycleState _appState = AppLifecycleState.resumed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeNotifications();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() => _appState = state);
    print('App lifecycle state changed to: $state');
  }

  Future<void> _initializeNotifications() async {
    _notificationService = NotificationService();

    try {
      // Initialize FCM
      await _notificationService.initializeNotifications();

      // Get FCM token
      final token = await _notificationService.getToken();
      setState(() {
        _fcmToken = token ?? 'Failed to get token';
        _initialized = true;
      });

      // Listen to foreground messages
      _notificationService.foregroundMessages.listen((message) {
        if (mounted) {
          setState(() {});
          _showNotificationSnackbar(message, 'FOREGROUND');
        }
      });

      // Listen to all messages
      _notificationService.allMessages.listen((message) {
        if (mounted) {
          setState(() {});
        }
      });

      // Subscribe to hospital shift updates topic
      await _notificationService.subscribeToTopic('shift_updates');
    } catch (e) {
      if (mounted) {
        setState(() {
          _fcmToken = 'Error: $e';
          _initialized = true;
        });
      }
      print('Error initializing FCM: $e');
    }
  }

  void _showNotificationSnackbar(
      NotificationMessage message, String state) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '[$state] ${message.title}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(message.body, maxLines: 2, overflow: TextOverflow.ellipsis),
          ],
        ),
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.blue.shade700,
      ),
    );
  }

  void _copyTokenToClipboard() {
    Clipboard.setData(ClipboardData(text: _fcmToken));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('FCM token copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _notificationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Notifications (FCM)'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // App state indicator
            _buildAppStateCard(),
            const SizedBox(height: 16),

            // FCM token card
            _buildTokenCard(),
            const SizedBox(height: 20),

            // Info card
            _buildInfoCard(),
            const SizedBox(height: 20),

            // Notification history
            _buildNotificationHistory(),
          ],
        ),
      ),
    );
  }

  /// Build app state indicator card
  Widget _buildAppStateCard() {
    const appStates = {
      AppLifecycleState.resumed: ('Foreground', Colors.green),
      AppLifecycleState.paused: ('Background', Colors.orange),
      AppLifecycleState.detached: ('Terminated', Colors.red),
      AppLifecycleState.hidden: ('Hidden', Colors.grey),
    };

    final (stateLabel, stateColor) = appStates[_appState] ?? ('Unknown', Colors.grey);

    return Card(
      elevation: 2,
      color: stateColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current App State',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: stateColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  stateLabel,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: stateColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              stateLabel == 'Foreground'
                  ? 'App is open and active. Notifications will appear in-app and as system notifications.'
                  : stateLabel == 'Background'
                      ? 'App is backgrounded. Notifications will appear as system notifications only.'
                      : stateLabel == 'Terminated'
                          ? 'App is closed. Notifications will appear as system notifications. Tap to launch app.'
                          : 'App state unknown.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  /// Build FCM token card
  Widget _buildTokenCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Device FCM Token',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            if (!_initialized)
              const SizedBox(
                height: 40,
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              SelectableText(
                _fcmToken,
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                  color: Colors.grey.shade700,
                ),
                toolbarOptions: const ToolbarOptions(copy: true),
              ),
            const SizedBox(height: 12),
            if (_initialized)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _copyTokenToClipboard,
                  icon: const Icon(Icons.copy),
                  label: const Text('Copy Token'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '💡 This token is required in Firebase Console to send test notifications. '
                'Copy this token and use it in Cloud Messaging > Send Test Message.',
                style: TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build info card
  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How to Test Push Notifications',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 12),
            _buildStep(
              '1',
              'Copy Device Token',
              'Copy the FCM token displayed above',
            ),
            const SizedBox(height: 12),
            _buildStep(
              '2',
              'Open Firebase Console',
              'Go to your Firebase project > Cloud Messaging',
            ),
            const SizedBox(height: 12),
            _buildStep(
              '3',
              'Send Test Message',
              'Click "Send test message" > Enter title & body > Select instance ID (use token above)',
            ),
            const SizedBox(height: 12),
            _buildStep(
              '4',
              'Observe Notification',
              'Check app state above. Notification will appear based on state (foreground/background/terminated)',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.amber),
              ),
              child: const Text(
                '⚠️ For testing: Title = "Shift Update", Body = "Urgent: Duty timing has changed."',
                style: TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build step widget
  Widget _buildStep(String number, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.blue.shade700,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build notification history
  Widget _buildNotificationHistory() {
    final messages = _notificationService.messageHistory;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notification History',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                if (messages.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      _notificationService.clearHistory();
                      setState(() {});
                    },
                    child: const Text('Clear'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (messages.isEmpty)
              Center(
                child: Text(
                  'No notifications yet. Send a test message from Firebase Console.',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return _buildNotificationCard(message, index);
                },
              ),
          ],
        ),
      ),
    );
  }

  /// Build notification card
  Widget _buildNotificationCard(NotificationMessage message, int index) {
    final sourceColors = {
      'foreground': Colors.green,
      'background': Colors.orange,
      'terminated': Colors.red,
      'system': Colors.blue,
    };

    final sourceColor = sourceColors[message.source] ?? Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: sourceColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(4),
        color: sourceColor.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: sourceColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  message.source.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${message.receivedAt.hour}:${message.receivedAt.minute}:${message.receivedAt.second}',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            message.body,
            style: const TextStyle(fontSize: 11),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (message.data != null && message.data!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Data: ${message.data}',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}
