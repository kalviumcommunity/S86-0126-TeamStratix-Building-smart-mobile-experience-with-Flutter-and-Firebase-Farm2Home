# Flutter Animations & Transitions - Quick Reference

## Animation Types at a Glance

### Implicit Animations (No Controller Needed)

| Widget | Purpose | Duration | Example |
|--------|---------|----------|---------|
| **AnimatedContainer** | Size, color, padding transitions | 300-800ms | Size/color changes on state |
| **AnimatedOpacity** | Fade in/out effects | 300-800ms | Show/hide content |
| **AnimatedAlign** | Position transitions | 300-800ms | Widget alignment changes |
| **AnimatedDefaultTextStyle** | Text property changes | 200-500ms | Text color/size transitions |
| **AnimatedPositioned** | Position in Stack | 300-800ms | Move widget in Stack |
| **AnimatedRotation** | Rotation without controller | 200-500ms | Icon rotations |
| **AnimatedScale** | Scale without controller | 200-500ms | Size changes |
| **AnimatedPadding** | Padding transitions | 200-500ms | Spacing changes |

---

## Explicit Animations (With AnimationController)

### Common Transitions

| Transition | Purpose | Use Case |
|------------|---------|----------|
| **RotationTransition** | Rotate child widget | Loading spinners, rotating icons |
| **ScaleTransition** | Scale child widget | Zoom in/out, pulsing effects |
| **SlideTransition** | Slide child widget | Page transitions, drawer reveal |
| **FadeTransition** | Fade child widget | Content entrance/exit |
| **SizeTransition** | Expand/collapse size | Collapsible sections |
| **PositionedTransition** | Animate position | Complex movements |

---

## Animation Durations Reference

```
⚡ Ultra-Fast     50-150ms   (Immediate feedback)
🔥 Fast           200-300ms  (Button presses, toggles)
⚙️  Standard       300-500ms  (Page transitions)
🎬 Moderate       500-800ms  (Entrance animations)
🔄 Slow           1-2s       (Continuous loops)
📍 Very Slow      2-5s       (Loading indicators)
```

---

## Animation Curves Cheat Sheet

```
Curves.linear              → Constant speed (loading spinners)
Curves.easeIn              → Slow start, fast end (entrance)
Curves.easeOut             → Fast start, slow end (exit)
Curves.easeInOut           → Slow both ends (general purpose) ✅
Curves.easeInCubic         → Smoother easeIn
Curves.easeOutCubic        → Smoother easeOut
Curves.elasticOut          → Bounce effect (sparingly)
Curves.bounceOut           → Bouncy landing
Curves.fastOutSlowIn       → Natural motion
```

---

## Code Snippets

### 1. Simple AnimatedContainer

```dart
bool _isExpanded = false;

AnimatedContainer(
  duration: Duration(milliseconds: 300),
  width: _isExpanded ? 200 : 100,
  height: _isExpanded ? 100 : 200,
  color: _isExpanded ? Colors.blue : Colors.red,
  curve: Curves.easeInOut,
  child: GestureDetector(
    onTap: () => setState(() => _isExpanded = !_isExpanded),
    child: Center(child: Text('Tap')),
  ),
)
```

### 2. AnimatedOpacity

```dart
AnimatedOpacity(
  opacity: _isVisible ? 1.0 : 0.0,
  duration: Duration(seconds: 1),
  child: Container(color: Colors.green, child: Text('Visible')),
)
```

### 3. Basic RotationTransition

```dart
late AnimationController _controller;

@override
void initState() {
  super.initState();
  _controller = AnimationController(
    duration: Duration(seconds: 2),
    vsync: this,
  )..repeat();
}

@override
void dispose() {
  _controller.dispose();
  super.dispose();
}

RotationTransition(
  turns: _controller,
  child: Icon(Icons.refresh, size: 48),
)
```

### 4. ScaleTransition with Tween

```dart
ScaleTransition(
  scale: Tween<double>(begin: 0.8, end: 1.2).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
  ),
  child: Container(width: 100, height: 100, color: Colors.purple),
)
```

### 5. Page Slide Transition

```dart
Navigator.push(
  context,
  PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 500),
    pageBuilder: (context, animation, secondaryAnimation) => NextPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        )),
        child: child,
      );
    },
  ),
);
```

### 6. Staggered List Animation

```dart
TweenAnimationBuilder<double>(
  tween: Tween(begin: 0.0, end: 1.0),
  duration: Duration(milliseconds: 300 + (index * 200)),
  builder: (context, value, child) {
    return Transform.translate(
      offset: Offset(0, (1 - value) * 50),
      child: Opacity(opacity: value, child: child),
    );
  },
  child: ListTile(title: Text('Item $index')),
)
```

---

## Farm2Home Animations Summary

### Implemented Components

✅ **AnimationsDemoScreen** - 6 animation examples  
✅ **AnimatedProductCard** - Product hover animations  
✅ **AnimatedButton** - Press feedback animations  
✅ **AnimatedFloatingActionButton** - FAB animations  
✅ **Page Transitions** - Slide transitions throughout app  

### Access Points

- **Demo Screen**: Navigate to `/animations` route
- **Product Cards**: Used in products listing
- **Custom Buttons**: Available throughout checkout flow
- **Page Navigation**: Automatic on all route transitions

---

## Common Pitfalls to Avoid

❌ **Too Long** - Animations > 1 second feel sluggish  
❌ **Too Many** - Multiple simultaneous complex animations cause lag  
❌ **Meaningless** - Animations with no purpose distract  
❌ **Blocking** - Never freeze UI during animation  
❌ **Inconsistent** - Different timing/curves confuse users  
❌ **Not Disposed** - Always dispose AnimationControllers  
❌ **No Curves** - Linear motion feels robotic  

---

## Performance Tips

✅ Use `AnimatedBuilder` to avoid rebuilding entire subtree  
✅ Choose implicit animations for simple state changes  
✅ Use `vsync: this` with `SingleTickerProviderStateMixin`  
✅ Keep animation durations under 800ms  
✅ Avoid animating expensive layouts  
✅ Test on low-end devices  
✅ Profile with DevTools to check frame rates  

---

## Testing Checklist

- [ ] Animations run at 60 FPS (no jank)
- [ ] No flickering or visual artifacts
- [ ] Animations feel natural with proper curves
- [ ] Duration is appropriate (not too fast/slow)
- [ ] Works on different screen sizes
- [ ] Animations don't block interactions
- [ ] Loading states are clear and animate smoothly
- [ ] Controller is properly disposed

---

**Quick Access**: Copy and use snippets for your own animations!  
**Reference**: Full documentation in ANIMATIONS_DOCUMENTATION.md  
**Examples**: Check animations_demo_screen.dart for implementation details
