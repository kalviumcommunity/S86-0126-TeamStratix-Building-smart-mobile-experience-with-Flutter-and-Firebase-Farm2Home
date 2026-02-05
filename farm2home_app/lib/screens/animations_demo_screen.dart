import 'package:flutter/material.dart';

/// Comprehensive animations demo showcasing implicit and explicit animations
class AnimationsDemoScreen extends StatefulWidget {
  const AnimationsDemoScreen({super.key});

  @override
  State<AnimationsDemoScreen> createState() => _AnimationsDemoScreenState();
}

class _AnimationsDemoScreenState extends State<AnimationsDemoScreen>
    with SingleTickerProviderStateMixin {
  bool _isToggled = false;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animations & Transitions Demo'),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('1. AnimatedContainer (Implicit)'),
            _buildAnimatedContainerDemo(),
            const SizedBox(height: 32),

            _buildSectionTitle('2. AnimatedOpacity (Implicit)'),
            _buildAnimatedOpacityDemo(),
            const SizedBox(height: 32),

            _buildSectionTitle('3. AnimatedAlign (Implicit)'),
            _buildAnimatedAlignDemo(),
            const SizedBox(height: 32),

            _buildSectionTitle('4. RotationTransition (Explicit)'),
            _buildRotationAnimationDemo(),
            const SizedBox(height: 32),

            _buildSectionTitle('5. ScaleTransition (Explicit)'),
            _buildScaleAnimationDemo(),
            const SizedBox(height: 32),

            _buildSectionTitle('6. Staggered List Animation'),
            _buildStaggeredListDemo(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
      ),
    );
  }

  /// 1. AnimatedContainer
  Widget _buildAnimatedContainerDemo() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _isToggled = !_isToggled),
          child: AnimatedContainer(
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            width: _isToggled ? 200 : 100,
            height: _isToggled ? 100 : 200,
            decoration: BoxDecoration(
              color: _isToggled ? Colors.teal : Colors.orange,
              borderRadius: BorderRadius.circular(_isToggled ? 20 : 0),
            ),
            child: Center(
              child: Text(
                _isToggled ? 'Expanded!' : 'Tap Me!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Click the box to toggle size and color smoothly',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  /// 2. AnimatedOpacity
  Widget _buildAnimatedOpacityDemo() {
    return Column(
      children: [
        AnimatedOpacity(
          opacity: _isToggled ? 1.0 : 0.2,
          duration: const Duration(seconds: 1),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.green[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.eco, size: 60, color: Colors.white),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => setState(() => _isToggled = !_isToggled),
          child: Text(_isToggled ? 'Fade Out' : 'Fade In'),
        ),
      ],
    );
  }

  /// 3. AnimatedAlign
  Widget _buildAnimatedAlignDemo() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[300]!),
      ),
      child: AnimatedAlign(
        alignment: _isToggled ? Alignment.bottomRight : Alignment.topLeft,
        duration: const Duration(milliseconds: 800),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.blue[400],
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 32),
        ),
      ),
    );
  }

  /// 4. RotationTransition
  Widget _buildRotationAnimationDemo() {
    return RotationTransition(
      turns: _rotationController,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.purple[400],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.agriculture, size: 50, color: Colors.white),
      ),
    );
  }

  /// 5. ScaleTransition
  Widget _buildScaleAnimationDemo() {
    return ScaleTransition(
      scale: Tween(begin: 0.8, end: 1.2).animate(
        CurvedAnimation(
          parent: _rotationController,
          curve: Curves.easeInOut,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red[300]!),
        ),
        child: Column(
          children: const [
            Icon(Icons.favorite, size: 48, color: Colors.red),
            SizedBox(height: 8),
            Text(
              'Pulsing Scale Animation',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  /// 6. Staggered List Animation (FIXED)
  Widget _buildStaggeredListDemo() {
    final items = ['Fresh Vegetables', 'Organic Fruits', 'Dairy Products'];
    final icons = [
      Icons.local_florist,
      Icons.cake,
      Icons.local_dairy,
    ];

    return Column(
      children: List.generate(items.length, (index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 300 + index * 200),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, (1 - value) * 50),
              child: Opacity(
                opacity: value,
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.green[400],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icons[index], color: Colors.white),
                    ),
                    title: Text(items[index]),
                    subtitle: const Text('Premium quality'),
                    trailing: const Icon(Icons.arrow_forward),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
