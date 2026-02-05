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
    // Initialize rotation animation controller
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section 1: AnimatedContainer
            _buildSectionTitle('1. AnimatedContainer (Implicit)'),
            _buildAnimatedContainerDemo(),
            const SizedBox(height: 32),

            // Section 2: AnimatedOpacity
            _buildSectionTitle('2. AnimatedOpacity (Implicit)'),
            _buildAnimatedOpacityDemo(),
            const SizedBox(height: 32),

            // Section 3: AnimatedAlignment
            _buildSectionTitle('3. AnimatedAlign (Implicit)'),
            _buildAnimatedAlignDemo(),
            const SizedBox(height: 32),

            // Section 4: Rotation Animation (Explicit)
            _buildSectionTitle('4. RotationTransition (Explicit)'),
            _buildRotationAnimationDemo(),
            const SizedBox(height: 32),

            // Section 5: Scale Animation (Explicit)
            _buildSectionTitle('5. ScaleTransition (Explicit)'),
            _buildScaleAnimationDemo(),
            const SizedBox(height: 32),

            // Section 6: List Animation
            _buildSectionTitle('6. Staggered List Animation'),
            _buildStaggeredListDemo(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  /// Section Title Widget
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
      ),
    );
  }

  /// 1. AnimatedContainer Demo
  Widget _buildAnimatedContainerDemo() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isToggled = !_isToggled;
            });
          },
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
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Click the box to toggle size and color smoothly',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  /// 2. AnimatedOpacity Demo
  Widget _buildAnimatedOpacityDemo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
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
                  child: const Icon(
                    Icons.eco,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isToggled = !_isToggled;
                  });
                },
                child: Text(_isToggled ? 'Fade Out' : 'Fade In'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 3. AnimatedAlign Demo
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

  /// 4. Rotation Animation Demo (Explicit)
  Widget _buildRotationAnimationDemo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.purple[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: RotationTransition(
            turns: _rotationController,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.purple[400],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.agriculture,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Continuous rotation animation (explicit with AnimationController)',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  /// 5. Scale Animation Demo (Explicit)
  Widget _buildScaleAnimationDemo() {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.8, end: 1.2).animate(
        CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red[300]!),
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.red[400],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Pulsing Scale Animation',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 6. Staggered List Animation
  Widget _buildStaggeredListDemo() {
    final items = ['Fresh Vegetables', 'Organic Fruits', 'Dairy Products'];
    return Column(
      children: List.generate(
        items.length,
        (index) => TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 300 + (index * 200)),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, (1 - value) * 50),
              child: Opacity(
                opacity: value,
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 4,
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.green[index % 2 == 0 ? 400 : 600],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        [Icons.local_florist, Icons.cake, Icons.shopping_basket]
                            [index],
                        color: Colors.white,
                      ),
                    ),
                    title: Text(items[index]),
                    subtitle: const Text('Premium quality'),
                    trailing: const Icon(Icons.arrow_forward),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
