# Responsive Design with MediaQuery & LayoutBuilder

## Overview

This documentation covers the comprehensive responsive design implementation for the Farm2Home app using Flutter's `MediaQuery` and `LayoutBuilder` widgets. Responsive design ensures that the app provides optimal viewing experience across different screen sizes and orientations.

## What is Responsive Design?

Responsive design is an approach to web and app design that makes web pages and applications responsive to the user's behavior and environment based on screen size, platform, and orientation.

**Key Principles:**
- **Fluid Layouts**: Use proportional measurements instead of fixed pixels
- **Flexible Grids**: Layouts that adapt to different column counts
- **Media Queries**: Apply different styles based on device characteristics
- **Adaptive Components**: UI elements that adjust their appearance and layout

## Key Concepts

### 1. MediaQuery

`MediaQuery` provides access to the size and other properties of the device screen.

**Common Use Cases:**

```dart
final screenWidth = MediaQuery.of(context).size.width;
final screenHeight = MediaQuery.of(context).size.height;
final orientation = MediaQuery.of(context).orientation;
final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
```

**Practical Example - Proportional Sizing:**

```dart
// Container takes 85% of screen width
Container(
  width: screenWidth * 0.85,
  height: 60,
  color: Colors.teal,
)
```

**Practical Example - Responsive Font:**

```dart
Text(
  'Adaptive Text',
  style: TextStyle(
    fontSize: screenWidth > 800 ? 32 : screenWidth > 600 ? 24 : 18,
  ),
)
```

### 2. LayoutBuilder

`LayoutBuilder` provides the actual constraints available to a widget, allowing conditional layouts based on available space.

**Key Advantage**: LayoutBuilder responds to parent constraints, not global screen size, making it more flexible for nested layouts.

**Practical Example - Responsive Grid:**

```dart
LayoutBuilder(
  builder: (context, constraints) {
    int columns;
    if (constraints.maxWidth < 600) {
      columns = 2;  // Mobile
    } else if (constraints.maxWidth < 900) {
      columns = 3;  // Tablet
    } else {
      columns = 4;  // Desktop
    }
    
    return GridView.count(
      crossAxisCount: columns,
      children: [...],
    );
  },
)
```

**Practical Example - Responsive Form:**

```dart
LayoutBuilder(
  builder: (context, constraints) {
    final isMobile = constraints.maxWidth < 600;
    
    if (isMobile) {
      // Stack fields vertically
      return Column(children: [...]);
    } else {
      // Place fields side by side
      return Row(children: [...]);
    }
  },
)
```

## Implementation Details

### Screen Sizes (Breakpoints)

The responsive design uses these breakpoints:

| Breakpoint | Width | Device Type |
|-----------|-------|-------------|
| Mobile | < 500 px | Phones |
| Tablet | 500-800 px | Small tablets |
| Large Tablet | 800-1200 px | Large tablets |
| Desktop | > 1200 px | Desktop/Web |

### 1. Responsive Design Demo Screen

**File**: `lib/screens/responsive_design_demo.dart`

**Features:**
- Device information display (width, height, orientation, DPI)
- MediaQuery examples (proportional sizing, dynamic padding, responsive font)
- LayoutBuilder examples (mobile vs tablet layouts)
- Responsive grid (2-4 columns based on width)
- Responsive form (stacked vs side-by-side)

**Key Implementation:**

```dart
// Screen info section
final screenWidth = MediaQuery.of(context).size.width;
final orientation = MediaQuery.of(context).orientation;

// Responsive grid
GridView.count(
  crossAxisCount: screenWidth < 600 ? 2 : screenWidth < 900 ? 3 : 4,
  children: [...],
)

// Responsive form using LayoutBuilder
LayoutBuilder(
  builder: (context, constraints) {
    final isMobile = constraints.maxWidth < 600;
    if (isMobile) {
      return Column(...);  // Stacked
    } else {
      return Row(...);     // Side-by-side
    }
  },
)
```

### 2. Responsive Product Grid

**File**: `lib/screens/responsive_product_grid.dart`

**Features:**
- Dynamic grid column count based on screen width
- Uses ProductCard component
- Responsive spacing
- Grid info display

**Column Breakpoints:**
- < 500 px: 2 columns
- 500-800 px: 3 columns
- 800-1200 px: 4 columns
- > 1200 px: 5 columns

**Key Implementation:**

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: columns,  // Dynamic column count
    crossAxisSpacing: 8,
    mainAxisSpacing: 8,
    childAspectRatio: 0.75,
  ),
  itemCount: products.length,
  itemBuilder: (context, index) {
    return ProductCard(product: products[index]);
  },
)
```

### 3. Responsive Form Layout

**File**: `lib/screens/responsive_form_layout.dart`

**Features:**
- Name fields: stacked on mobile, side-by-side on tablet
- Contact fields: full-width
- Address fields: city, state, ZIP - stacked on mobile, 3-column on tablet
- Form validation
- Responsive button

**Mobile Layout:**
```
[First Name]
[Last Name]
[Email]
[Phone]
[Address]
[City]
[State]
[ZIP]
[Submit]
```

**Tablet Layout:**
```
[First Name] [Last Name]
[Email]
[Phone]
[Address]
[City] [State] [ZIP]
[Submit]
```

**Key Implementation:**

```dart
LayoutBuilder(
  builder: (context, constraints) {
    final isMobile = constraints.maxWidth < 600;
    
    if (isMobile) {
      return Column(
        children: [
          firstNameField,
          SizedBox(height: 12),
          lastNameField,
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(child: firstNameField),
          SizedBox(width: 12),
          Expanded(child: lastNameField),
        ],
      );
    }
  },
)
```

## Responsive Design Patterns

### Pattern 1: Dynamic Font Sizing

```dart
Text(
  'Hello',
  style: TextStyle(
    fontSize: screenWidth > 800 ? 32 : 18,
  ),
)
```

### Pattern 2: Proportional Padding

```dart
Container(
  padding: EdgeInsets.all(screenWidth * 0.05),
  child: Text('Content'),
)
```

### Pattern 3: Conditional Visibility

```dart
if (MediaQuery.of(context).size.width > 600)
  SizedBox(width: 16),  // Extra spacing on tablets
```

### Pattern 4: Device Orientation

```dart
if (MediaQuery.of(context).orientation == Orientation.landscape)
  // Landscape layout
else
  // Portrait layout
```

## Testing Responsive Design

### Using Chrome DevTools

1. Open app in Chrome web browser
2. Press F12 or Ctrl+Shift+I
3. Click device toggle (Ctrl+Shift+M)
4. Test different screen sizes by dragging the viewport

### Using Flutter DevTools

1. Run app in debug mode
2. Open Flutter DevTools (flutter pub global run devtools)
3. Use the inspector to check widget tree at different sizes
4. Rotate device simulator to test orientations

### Manual Testing

1. **Mobile (320x568)**
   - iPhone SE
   - Pixel 3a

2. **Tablet (600x960)**
   - iPad mini
   - Galaxy Tab S

3. **Large Tablet (1024x768)**
   - iPad Air
   - Galaxy Tab S3

4. **Landscape Orientation**
   - Verify all layouts still work

## Common Responsive Design Mistakes to Avoid

❌ **Don't**: Use fixed pixel widths
```dart
// BAD
Container(width: 300)
```

✅ **Do**: Use proportional or flexible sizing
```dart
// GOOD
Container(width: screenWidth * 0.8)
// or
Expanded(child: Container())
```

❌ **Don't**: Forget about landscape orientation
```dart
// BAD - only works in portrait
if (screenWidth < 600) Column(...) else Row(...)
```

✅ **Do**: Consider both dimensions
```dart
// GOOD
if (screenWidth < 600 || screenHeight < 500)
  Column(...)
else
  Row(...)
```

❌ **Don't**: Use only MediaQuery for nested layouts
```dart
// BAD - doesn't work correctly with padding/constraints
final width = MediaQuery.of(context).size.width;
Container(width: width * 0.9)
```

✅ **Do**: Use LayoutBuilder for nested constraints
```dart
// GOOD
LayoutBuilder(builder: (context, constraints) {
  return Container(width: constraints.maxWidth * 0.9);
})
```

## Performance Considerations

### Use const Constructors
```dart
const SizedBox(height: 16)  // Can be const
```

### Avoid Rebuilds
```dart
// Cache MediaQuery values in local variables
final screenWidth = MediaQuery.of(context).size.width;
```

### Use LayoutBuilder for Flexibility
- LayoutBuilder responds to parent constraints
- More efficient than constantly querying MediaQuery
- Enables responsive components at any nesting level

## Code Examples

### Example 1: Responsive Card

```dart
Card(
  child: LayoutBuilder(
    builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 400;
      
      return isMobile
          ? Column(
              children: [
                Image.network(imageUrl),
                SizedBox(height: 16),
                Text(title),
              ],
            )
          : Row(
              children: [
                Image.network(imageUrl),
                SizedBox(width: 16),
                Expanded(child: Text(title)),
              ],
            );
    },
  ),
)
```

### Example 2: Responsive Navigation

```dart
AppBar(
  title: Text('Farm2Home'),
  actions: [
    if (MediaQuery.of(context).size.width > 600)
      TextButton(onPressed: () {}, child: Text('Home')),
    if (MediaQuery.of(context).size.width > 600)
      TextButton(onPressed: () {}, child: Text('Products')),
    PopupMenuButton(itemBuilder: (_) => [...]),
  ],
)
```

### Example 3: Responsive Padding

```dart
Padding(
  padding: EdgeInsets.symmetric(
    horizontal: screenWidth > 600 ? 32 : 16,
    vertical: screenHeight > 600 ? 24 : 12,
  ),
  child: Text('Content'),
)
```

## Accessibility Considerations

1. **Text Scaling**: Respect user's text scale preference
   ```dart
   Text('Large Text',
     textScaleFactor: MediaQuery.of(context).textScaleFactor,
   )
   ```

2. **Touch Targets**: Ensure buttons are at least 48x48 dp
   ```dart
   SizedBox(
     width: 48,
     height: 48,
     child: ElevatedButton(...)
   )
   ```

3. **Contrast**: Maintain color contrast across all sizes

## Summary

Responsive design with MediaQuery and LayoutBuilder enables:

✅ Optimal viewing on all device sizes
✅ Flexible and maintainable code
✅ Better user experience
✅ Single codebase for multiple platforms
✅ Professional app appearance

By following these patterns and practices, you can create truly responsive Flutter applications that work beautifully on phones, tablets, and beyond.

---

**Next Steps:**
- Test the responsive demo screens at different sizes
- Apply responsive patterns to main ProductsScreen
- Implement landscape orientation support
- Add tablet-specific optimizations
