import 'package:flutter/material.dart';

class WeatherAlertsScreen extends StatelessWidget {
  const WeatherAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather & Alerts'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Current Weather Card
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(0.8),
                        Theme.of(context).primaryColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '28°C',
                            style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.wb_sunny, color: Colors.amber.shade300, size: 48),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text('Partly Cloudy', style: TextStyle(color: Colors.white, fontSize: 16)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildWeatherInfo('💧', 'Humidity: 65%'),
                          const SizedBox(width: 16),
                          _buildWeatherInfo('💨', 'Wind: 12 km/h'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 7-Day Forecast
                  Text('7-Day Forecast', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildForecastCard('Mon', '28°C', '☀️'),
                        _buildForecastCard('Tue', '26°C', '🌤️'),
                        _buildForecastCard('Wed', '24°C', '🌧️'),
                        _buildForecastCard('Thu', '22°C', '⛈️'),
                        _buildForecastCard('Fri', '25°C', '🌦️'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Alerts
                  Text('Active Alerts', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _buildAlertCard(
                    '⚠️',
                    Colors.orange,
                    'Heavy Rain Expected',
                    'Tomorrow 2-6 PM\nAvoid fertilizer application',
                  ),
                  _buildAlertCard(
                    '🌡️',
                    Colors.red,
                    'High Temperature',
                    'Next 3 days\nIncrease irrigation frequency',
                  ),

                  const SizedBox(height: 24),

                  // Tips
                  Text('Smart Tips', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _buildTipCard('💡', 'Avoid spraying during peak heat (12-4 PM)'),
                  _buildTipCard('💡', 'Water plants early morning for better absorption'),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(String emoji, String text) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 13)),
      ],
    );
  }

  Widget _buildForecastCard(String day, String temp, String emoji) {
    return Card(
      margin: const EdgeInsets.only(right: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(temp, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(String icon, Color color, String title, String message) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                  const SizedBox(height: 4),
                  Text(message, style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(String icon, String text) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
          ],
        ),
      ),
    );
  }
}
