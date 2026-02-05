# Responsive Design - Quick Reference

## MediaQuery vs LayoutBuilder Quick Comparison

| Feature | MediaQuery | LayoutBuilder |
|---------|-----------|---------------|
| **What it provides** | Global screen dimensions | Parent widget constraints |
| **Best for** | Screen-level decisions | Component-level adaptation |
| **Efficiency** | Broadcasts to all listeners | Local constraints only |
| **Rebuild triggers** | Screen size changes | Parent constraint changes |
| **Use case** | AppBar height, navigation | Nested components, cards |

## Common Breakpoints

```dart
// Mobile (Phone)
if (screenWidth < 500) { }

// Tablet (Small)
if (screenWidth >= 500 && screenWidth < 800) { }

// Tablet (Large)
if (screenWidth >= 800 && screenWidth < 1200) { }

// Desktop
if (screenWidth >= 1200) { }
```

## Quick Code Snippets

### 1. Get Screen Dimensions

```dart
final screenWidth = MediaQuery.of(context).size.width;
final screenHeight = MediaQuery.of(context).size.height;
final orientation = MediaQuery.of(context).orientation;
final padding = MediaQuery.of(context).padding;  // Safe area
```

### 2. Responsive Grid

```dart
GridView.count(
  crossAxisCount: screenWidth < 600 ? 2 : 3,
  children: [...],
)
```

### 3. Responsive Column/Row

```dart
LayoutBuilder(
  builder: (context, constraints) {
    return constraints.maxWidth < 600
        ? Column(children: [...])  // Mobile
        : Row(children: [...]);     // Tablet
  },
)
```

### 4. Responsive Padding

```dart
Container(
  padding: EdgeInsets.all(screenWidth < 600 ? 16 : 24),
  child: child,
)
```

### 5. Responsive Font

```dart
Text(
  'Hello',
  style: TextStyle(
    fontSize: screenWidth < 600 ? 18 : 24,
  ),
)
```

### 6. Safe Area (Notch/Status Bar)

```dart
SafeArea(
  child: Column(
    children: [...],
  ),
)

// Or manually:
final padding = MediaQuery.of(context).padding;
Padding(
  padding: EdgeInsets.only(top: padding.top),
  child: child,
)
```

### 7. Device Orientation

```dart
if (MediaQuery.of(context).orientation == Orientation.landscape) {
  // Landscape layout
} else {
  // Portrait layout
}
```

### 8. Responsive Expanded

```dart
Row(
  children: [
    Expanded(
      flex: screenWidth < 600 ? 1 : 2,
      child: Container(),
    ),
    SizedBox(width: 16),
    Expanded(
      flex: screenWidth < 600 ? 1 : 1,
      child: Container(),
    ),
  ],
)
```

## Testing Checklist

- [ ] Test on phone width (< 500 px)
- [ ] Test on tablet width (500-1200 px)
- [ ] Test on large width (> 1200 px)
- [ ] Test landscape orientation
- [ ] Test with increased text scale
- [ ] Test with safe areas (notches)
- [ ] Test nested layouts
- [ ] Check Flutter DevTools inspector at each size

## Implementation Steps

1. **Identify breakpoints** - Where should layout change?
2. **Choose technique**:
   - Global decisions → MediaQuery
   - Component decisions → LayoutBuilder
3. **Test at all breakpoints** - Use Chrome DevTools or simulator rotation
4. **Check accessibility** - Touch targets 48x48+, good contrast
5. **Verify performance** - No unnecessary rebuilds

## Pro Tips

💡 **Tip 1**: Use LayoutBuilder inside components for reusability
```dart
// Widget is responsive regardless of parent width
class MyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adapts to parent size automatically
      },
    );
  }
}
```

💡 **Tip 2**: Combine MediaQuery and LayoutBuilder
```dart
// Use MediaQuery for app-level, LayoutBuilder for components
final isDarkMode = MediaQuery.of(context).platformBrightness;
// ...
LayoutBuilder(builder: (context, constraints) { })
```

💡 **Tip 3**: Extract responsive logic to separate methods
```dart
bool _isMobile(BuildContext context) {
  return MediaQuery.of(context).size.width < 600;
}

// Use in build:
if (_isMobile(context)) { }
```

💡 **Tip 4**: Use const constructors where possible
```dart
const SizedBox(height: 16)
// Avoids rebuilds
```

## Common Issues & Solutions

### Issue: Layout breaks on landscape
**Solution**: Check both width AND height
```dart
final isMobile = screenWidth < 600 || screenHeight < 500;
```

### Issue: Text overflows on small screens
**Solution**: Use flexible text widgets
```dart
Expanded(
  child: Text(
    'Long text',
    overflow: TextOverflow.ellipsis,
    maxLines: 2,
  ),
)
```

### Issue: Images distort on different sizes
**Solution**: Use fit property
```dart
Image.network(
  url,
  fit: BoxFit.cover,  // Maintain aspect ratio
)
```

### Issue: LayoutBuilder not updating
**Solution**: Check parent constraints change
```dart
// Parent must rebuild for LayoutBuilder to update
// Ensure widget rebuilds when screen rotates
```

## Resources

**Official Documentation:**
- [MediaQuery Class](https://api.flutter.dev/flutter/widgets/MediaQuery-class.html)
- [LayoutBuilder Class](https://api.flutter.dev/flutter/widgets/LayoutBuilder-class.html)
- [Flutter Responsive Design](https://flutter.dev/docs/development/ui/layout/adaptive-responsive)

**Demo Screens in App:**
- `/responsive-design` - Full MediaQuery & LayoutBuilder examples
- `/responsive-product-grid` - Adaptive grid layout
- `/responsive-form` - Responsive form layout

**Files:**
- `lib/screens/responsive_design_demo.dart` - Main demo
- `lib/screens/responsive_product_grid.dart` - Grid examples
- `lib/screens/responsive_form_layout.dart` - Form examples
