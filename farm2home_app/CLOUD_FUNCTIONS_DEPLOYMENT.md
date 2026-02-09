# Cloud Functions Deployment & Setup Guide

## Prerequisites

Before deploying Cloud Functions, ensure you have:

1. **Firebase CLI installed**
   ```bash
   npm install -g firebase-tools
   ```

2. **Firebase project initialized**
   ```bash
   firebase login
   firebase init functions
   ```

3. **Node.js 16+ installed**
   ```bash
   node --version  # Should be 16.x or higher
   npm --version   # Should be 6.x or higher
   ```

## Directory Structure

```
farm2home_app/
├── functions/
│   ├── index.js                    # Cloud Functions code
│   ├── package.json                # Node dependencies
│   └── node_modules/               # Installed packages
├── lib/
│   ├── services/
│   │   └── cloud_function_service.dart
│   └── screens/
│       └── cloud_functions_demo_screen.dart
└── firebase.json                   # Firebase configuration
```

## Setup Cloud Functions

### 1. Initialize Functions Directory

If not already initialized:

```bash
cd farm2home_app
firebase init functions
```

Select options:
- **Language**: JavaScript
- **ESLint**: Yes (for code quality)
- **npm install**: Yes

### 2. Install Dependencies

In the `functions` directory:

```bash
cd functions
npm install
```

Required packages should be in `package.json`:
```json
{
  "dependencies": {
    "firebase-functions": "^4.5.0",
    "firebase-admin": "^12.0.0"
  }
}
```

### 3. Copy Functions Code

Replace `functions/index.js` with the provided implementation:
- 5 callable functions (sayHello, calculateSum, getServerTime, sendWelcomeMessage, processImage)
- 3 event-triggered functions (onUserCreated, onOrderCreated, cleanupOldNotifications)
- Comprehensive logging for Firebase Console visibility

## Local Testing

### 1. Start Firebase Emulator

```bash
firebase emulators:start --only functions
```

This starts:
- Cloud Functions emulator (localhost:5001)
- Firestore emulator (localhost:8080)
- Local Firebase authentication

### 2. Test Callable Function

In Flutter app, functions will automatically use localhost during emulation:

```dart
// The CloudFunctionService will automatically connect to emulator
final response = await CloudFunctionService().callSayHello('Test');
```

Check emulator output for logs.

### 3. Monitor Emulator Logs

Emulator console shows:
```
Functions HTTP endpoint: http://localhost:5001/farm2home-project/us-central1
Functions emulator: Running...

sayHello function invoked:
  Request: {"name": "Test"}
  Response: {"message": "Hello, Test!", ...}
```

## Deployment to Firebase

### 1. Deploy All Functions

```bash
firebase deploy --only functions
```

Output:
```
Deploying functions to farm2home-project...
✔ functions[sayHello] deployed
✔ functions[calculateSum] deployed
✔ functions[getServerTime] deployed
✔ functions[sendWelcomeMessage] deployed
✔ functions[processImage] deployed
✔ functions[onUserCreated] deployed
✔ functions[onOrderCreated] deployed
✔ functions[cleanupOldNotifications] deployed

Deployment complete!
```

### 2. Deploy Specific Function

```bash
# Deploy single function
firebase deploy --only functions:sayHello

# Deploy multiple functions
firebase deploy --only functions:sayHello,functions:calculateSum
```

### 3. View Deployment Status

```bash
firebase functions:list
```

Shows:
```
Functions in project farm2home-project:
sayHello
calculateSum
getServerTime
sendWelcomeMessage
processImage
onUserCreated
onOrderCreated
cleanupOldNotifications
```

## Monitoring & Debugging

### View Logs in Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Navigate to **Functions** → **Logs**
4. Filter by:
   - Function name
   - Log level (DEBUG, INFO, ERROR)
   - Time range

### View Logs via CLI

```bash
# View all function logs
firebase functions:log

# View specific function logs
firebase functions:log --function=sayHello

# View last 50 lines
firebase functions:log -n 50

# Real-time log streaming
firebase functions:log --tail
```

### Example Log Output

```
sayHello                 12:34:56.123  sayHello called with name: John
sayHello                 12:34:56.145  sayHello response
                                       {"name":"John","message":"Hello, John!","timestamp":"2024-01-15T17:34:56.145Z"}
calculateSum             12:34:57.234  calculateSum called with a: 10, b: 20
calculateSum             12:34:57.256  calculateSum response
                                       {"a":10,"b":20,"sum":30,"timestamp":"2024-01-15T17:34:57.256Z"}
```

## Performance Monitoring

### 1. Check Execution Time

In Firebase Console:
- **Functions** → **Performance** → Select function
- View average execution time, P50, P95, P99 percentiles

### 2. Monitor Memory Usage

- **Functions** → **Memory Usage**
- Allocated vs actual memory
- Identify memory leaks

### 3. Track Invocation Count

- **Functions** → **Invocations**
- Requests/second trend
- Error rate percentage

## Configuration & Environment

### 1. Set Environment Variables

```bash
# Set variables
firebase functions:config:set mailgun.key="your-key" mailgun.domain="your-domain"

# View variables
firebase functions:config:get

# In Cloud Function
const mailgunKey = functions.config().mailgun.key;
```

### 2. Set Resource Configuration

Edit `firebase.json`:

```json
{
  "functions": {
    "source": "functions",
    "runtime": "nodejs18",
    "regions": ["us-central1", "europe-west1"],
    "configs": {
      "memory": "256MB",
      "timeout": 60,
      "maxInstances": 100
    }
  }
}
```

### 3. Regional Deployment

```bash
# Deploy to specific region
firebase functions:delete sayHello --region us-east1
firebase deploy --only functions:sayHello
```

## Cost Management

### 1. Pricing Structure

- **Invocations**: $0.40 per 1M invocations
- **Compute time**: $0.0000025 per GB-second
- **Networking**: Egress charges apply

### 2. Cost Optimization

1. **Reduce cold starts**
   - Use minimum instances
   - Keep functions lightweight
   - Reuse connections

2. **Optimize execution time**
   - Cache results
   - Use indexes on Firestore
   - Minimize external API calls

3. **Monitor quotas**
   - Set up quota alerts
   - Review usage regularly
   - Delete unused functions

## Troubleshooting

### Deployment Fails

**Error**: "Deploy had errors"

**Solution**:
```bash
# Check for syntax errors
npm run lint

# Verify Firebase config
firebase projects:list

# Clear cache and retry
rm -rf node_modules
npm install
firebase deploy --only functions
```

### Function Not Found

**Error**: "Error: Functions not deployed"

**Solution**:
```bash
# Verify functions exist
firebase functions:list

# Redeploy
firebase deploy --only functions --force
```

### Timeout Errors

**Error**: "Function execution timed out"

**Solution**:
```javascript
// In index.js, increase timeout
exports.slowFunction = functions
  .runWith({ timeoutSeconds: 300 })
  .https.onCall(async (data, context) => {
    // Function code
  });
```

### Memory Issues

**Error**: "Exceeded available memory"

**Solution**:
```javascript
// In index.js, increase memory
exports.memoryHeavyFunction = functions
  .runWith({ memory: '512MB' })
  .https.onCall(async (data, context) => {
    // Function code
  });
```

### Firestore Permission Denied

**Error**: "Missing or insufficient permissions"

**Solution**:

1. **Enable Firestore in Firebase Console**
   - Project Settings → Firestore
   - Create database in native mode

2. **Update Firestore Security Rules**
   ```
   match /databases/{database}/documents {
     match /{document=**} {
       allow read, write: if request.auth != null;
     }
   }
   ```

3. **Redeploy functions**
   ```bash
   firebase deploy --only firestore:rules,functions
   ```

## Security Best Practices

1. **Validate all inputs**
   ```javascript
   if (!data.name || typeof data.name !== 'string') {
     throw new functions.https.HttpsError(...);
   }
   ```

2. **Check authentication**
   ```javascript
   if (!context.auth) {
     throw new functions.https.HttpsError('unauthenticated', ...);
   }
   ```

3. **Rate limit functions**
   ```javascript
   // Use Firebase Extensions or Cloud Tasks
   ```

4. **Never expose secrets**
   ```javascript
   // Use environment variables
   const apiKey = functions.config().external.api_key;
   ```

5. **Log sensitive operations**
   ```javascript
   console.info('Sensitive operation', {
     userId: userId,
     action: 'delete',
     timestamp: new Date()
   });
   ```

## Production Checklist

Before deploying to production:

- [ ] All functions tested locally with emulator
- [ ] Error handling implemented for all edge cases
- [ ] Input validation on all parameters
- [ ] Firestore indexes created for queries
- [ ] Security rules configured
- [ ] Environment variables set
- [ ] Logging implemented for monitoring
- [ ] Cost estimates reviewed
- [ ] Memory/timeout settings optimized
- [ ] Disaster recovery plan documented

## Next Steps

1. ✅ Create Cloud Functions code (functions/index.js)
2. ⏳ Set up local emulator and test
3. ⏳ Deploy to Firebase
4. ⏳ Verify logs in Firebase Console
5. ⏳ Test from Flutter app
6. ⏳ Monitor performance metrics
7. ⏳ Implement event-triggered functions

---

**Related Documentation**
- [Cloud Functions Quick Reference](CLOUD_FUNCTIONS_QUICK_REFERENCE.md)
- [Cloud Functions Documentation](CLOUD_FUNCTIONS_DOCUMENTATION.md)
- [Firebase CLI Reference](https://firebase.google.com/docs/cli)
- [Cloud Functions Best Practices](https://firebase.google.com/docs/functions/bestpractices/retries)
