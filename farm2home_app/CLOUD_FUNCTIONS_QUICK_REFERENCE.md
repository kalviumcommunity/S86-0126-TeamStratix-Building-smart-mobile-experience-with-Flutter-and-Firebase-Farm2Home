# Cloud Functions Quick Reference

## Quick Start

### 1. Using CloudFunctionService

```dart
import 'services/cloud_function_service.dart';

final service = CloudFunctionService();

// Call sayHello
final response = await service.callSayHello('John');
if (response.success) {
  print(response.data); // Output: Hello, John!
} else {
  print(response.error);
}
```

### 2. Navigate to Demo Screen

```dart
// From any screen
Navigator.pushNamed(context, '/cloud-functions');
```

## Common Patterns

### Type-Safe Function Calling

```dart
// ✅ CORRECT - Type explicit
final response = await service.calculateSum(10, 20);

// ❌ AVOID - Loose typing
final response = await service.callFunction('calculateSum', params);
```

### Error Handling

```dart
final response = await service.callSayHello(name);

if (response.success) {
  // Handle success
  setState(() => _result = response.data.toString());
} else {
  // Handle error
  _showError(response.error ?? 'Unknown error');
}
```

### Response Display in UI

```dart
// Wrap in Card/Container for styling
Container(
  padding: EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: Colors.blue.shade50,
    border: Border.all(color: Colors.blue),
    borderRadius: BorderRadius.circular(4),
  ),
  child: SelectableText(
    response.data.toString(),
    style: TextStyle(fontSize: 12),
  ),
)
```

## Function Reference

| Function | Parameters | Returns | Purpose |
|----------|-----------|---------|---------|
| `callSayHello(name)` | `String name` | `{message, timestamp}` | Basic greeting |
| `calculateSum(a, b)` | `int a, int b` | `{a, b, sum, timestamp}` | Add two numbers |
| `getServerTime()` | None | `{timestamp, unixTime}` | Get server time |
| `sendWelcomeMessage(id, email, name)` | `String id, email, name` | `{success, message, timestamp}` | Send welcome email |
| `processImage(url, filter)` | `String url, filter` | `{success, processedImageUrl, filter}` | Process image |
| `callFunction(name, params)` | Generic | Response | Call any function |

## Cloud Functions CLI

```bash
# List all functions
firebase functions:list

# View logs
firebase functions:log

# Deploy all functions
firebase deploy --only functions

# Deploy specific function
firebase deploy --only functions:sayHello

# Delete function
firebase functions:delete sayHello

# Set environment variables
firebase functions:config:set mailgun.key="..." mailgun.domain="..."
```

## Demo UI Features

### Function Selector
- Easy selection of 3 main functions
- Input fields for parameters
- Call buttons for each function

### Response Display
- Shows success/error in distinct cards
- Includes timestamp and status
- Selectable text for copying

### Call History
- Tracks last 20 function calls
- Shows function name and result summary
- Clear button to reset history

## Testing Checklist

```
[ ] sayHello works with different names
[ ] calculateSum adds correctly
[ ] getServerTime returns valid timestamp
[ ] Error handling shows proper messages
[ ] Response display is readable
[ ] Call history tracks calls properly
[ ] Navigate from home screen works
[ ] UI is responsive on different screen sizes
```

## Troubleshooting

### "Function not found" Error
```
→ Ensure Cloud Functions are deployed to Firebase
→ Check function name matches exactly
→ Verify Firebase project is configured
```

### "No response" / Timeout
```
→ Check internet connection
→ Verify Firebase project is active
→ Check if Cloud Functions quota exceeded
→ Increase timeouts in service (if needed)
```

### UI Errors
```
→ Ensure cloud_functions_demo_screen imported in main.dart
→ Verify route '/cloud-functions' is registered
→ Check CloudFunctionService is instantiated properly
```

## Performance Tips

1. **Minimize initialization time** - Lazy load service when screen opens
2. **Cache responses** - Store successful results locally
3. **Handle loading states** - Show progress indicator during calls
4. **Batch calls** - Combine multiple requests when possible
5. **Monitor execution time** - Firebase Console → Functions → Logs

## Next Steps

1. ✅ UI layer complete - test from app
2. ⏳ Deploy Cloud Functions backend
3. ⏳ Verify logs in Firebase Console
4. ⏳ Implement event-triggered functions
5. ⏳ Add to production deployment

---

**Quick Navigation**
- [Full Documentation](CLOUD_FUNCTIONS_DOCUMENTATION.md)
- [CloudFunctionService Code](lib/services/cloud_function_service.dart)
- [Demo Screen Code](lib/screens/cloud_functions_demo_screen.dart)
- [Firebase Console](https://console.firebase.google.com)
