# Assets Management - Quick Reference

## One-Minute Setup

### 1. Create Folders
```
assets/
├── images/
└── icons/
```

### 2. Register in pubspec.yaml
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
```

### 3. Run
```bash
flutter pub get
```

---

## Code Snippets

### Display Local Image
```dart
Image.asset('assets/images/logo.png', width: 200)
```

### Material Icons (1000+ available)
```dart
Icon(Icons.home, size: 32, color: Colors.blue)
```

### Cupertino Icons (iOS style)
```dart
import 'package:flutter/cupertino.dart';
Icon(CupertinoIcons.heart, size: 32)
```

### Background Image
```dart
Container(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/bg.png'),
      fit: BoxFit.cover,
    ),
  ),
)
```

### Icon with Label
```dart
Column(
  children: [
    Icon(Icons.favorite, size: 32),
    Text('Favorite'),
  ],
)
```

### Product Card
```dart
Card(
  child: Row(
    children: [
      Image.asset('assets/images/product.png', width: 100),
      SizedBox(width: 16),
      Expanded(
        child: Column(
          children: [
            Text('Product'),
            Icon(Icons.star, color: Colors.amber),
          ],
        ),
      ),
    ],
  ),
)
```

---

## Popular Material Icons

| Icon | Code | Use Case |
|------|------|----------|
| 🏠 | `Icons.home` | Home/Dashboard |
| 🛒 | `Icons.shopping_cart` | Shopping cart |
| ❤️ | `Icons.favorite` | Favorites/Like |
| ⭐ | `Icons.star` | Ratings |
| ⚙️ | `Icons.settings` | Settings |
| 🔍 | `Icons.search` | Search |
| 🔔 | `Icons.notifications` | Notifications |
| 👤 | `Icons.person` | Profile |
| 📧 | `Icons.email` | Email/Mail |
| 📍 | `Icons.location_on` | Location |
| 📱 | `Icons.phone` | Phone/Call |
| 🗑️ | `Icons.delete` | Delete/Trash |
| ✏️ | `Icons.edit` | Edit |
| ✅ | `Icons.check_circle` | Success |
| ⚠️ | `Icons.warning` | Warning |

**Full list**: https://fonts.google.com/icons

---

## Icon Sizes
- Tiny: 16px - small labels
- Small: 24px - in text  
- Normal: 32px - default
- Large: 48px - featured
- XLarge: 64px+ - hero images

---

## BoxFit Options
- `cover` - Fill space, may crop
- `contain` - Fit entire image
- `fill` - Stretch to fill
- `fitWidth` - Fit width only
- `fitHeight` - Fit height only
- `scaleDown` - Scale down if needed

---

## Common Issues

| Problem | Solution |
|---------|----------|
| Image not showing | Check path in code, register in pubspec.yaml |
| YAML error | Use 2 spaces indentation, add trailing `/` |
| Icon not found | Check Icons class, use correct name |
| Hot reload not working | Run `flutter pub get` |
| Image quality poor | Compress/optimize before adding |

---

## File Size Targets
- Logo: < 50 KB
- Banner: < 200 KB
- Thumbnail: < 100 KB
- Icon: < 10 KB
- Total assets: < 5 MB

---

## Best Practices Checklist

✅ Organize assets in folders
✅ Use 2-space YAML indentation  
✅ Register all asset paths
✅ Use descriptive filenames
✅ Optimize images (compress)
✅ Test on multiple screen sizes
✅ Provide fallback/placeholder
✅ Use consistent icon sizes
✅ Comment icon usage
✅ Keep assets organized as project grows

---

## Asset Types Comparison

| Type | Format | Use | Registration |
|------|--------|-----|--------------|
| Local Image | PNG, JPG, WebP | Photos, graphics | Yes |
| Built-in Icon | Material | UI controls | No* |
| Custom Icon | PNG | Branded icons | Yes |
| Font | TTF, OTF | Typography | Yes |

*Material icons included automatically with Material Design

---

## Asset Demo Screen

Navigate to **Assets & Icons** in the app to see:
- Material Icons gallery
- Cupertino Icons gallery  
- Icon sizing examples
- Icon color variations
- Image asset examples
- Layout combinations
- pubspec.yaml configuration reference

---

## Documentation Files

- **ASSETS_MANAGEMENT_DOCUMENTATION.md** - Complete guide
- **ASSETS_MANAGEMENT_QUICK_REFERENCE.md** - This file
- **ASSETS_MANAGEMENT_SUBMISSION.md** - PR submission guide
- **assets/images/README.md** - Image asset notes
- **assets/icons/README.md** - Icon asset notes

