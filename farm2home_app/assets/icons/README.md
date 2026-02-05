# Icon Assets

This folder contains custom icon assets for the Farm2Home app.

## Recommended Custom Icons

Add PNG icons (transparent background) for:

1. **star.png** (64x64px) - Star rating icon
2. **heart.png** (64x64px) - Favorite/like icon  
3. **cart.png** (64x64px) - Shopping cart icon
4. **farm.png** (64x64px) - Farm/agriculture icon
5. **produce.png** (64x64px) - Produce/vegetables icon
6. **farmer.png** (64x64px) - Farmer/user icon

## Using Custom Icons

```dart
Image.asset(
  'assets/icons/star.png',
  width: 32,
  height: 32,
)
```

## Using Built-in Flutter Icons

Flutter includes 1000+ Material Design icons that don't need registration:

```dart
Icon(Icons.star, size: 32, color: Colors.amber)
Icon(Icons.favorite, size: 32, color: Colors.red)
Icon(Icons.shopping_cart, size: 32, color: Colors.blue)
```

## Icon Best Practices

- Use PNG with transparent backgrounds
- Provide consistent sizing (32x32, 48x48, 64x64)
- Keep icons simple and recognizable
- Use single color icons for consistency
- Consider providing both filled and outline versions
