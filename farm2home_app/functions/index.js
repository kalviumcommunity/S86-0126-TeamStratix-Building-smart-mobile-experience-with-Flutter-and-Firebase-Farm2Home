const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
admin.initializeApp();

const db = admin.firestore();

/**
 * Cloud Functions for Farm2Home Application
 * 
 * Callable Functions:
 * - sayHello: Basic greeting demonstration
 * - calculateSum: Server-side arithmetic
 * - getServerTime: Retrieve server timestamp
 * - sendWelcomeMessage: Send welcome notification
 * - processImage: Simulate image processing
 * 
 * Event-Triggered Functions:
 * - onUserCreated: Trigger when new user document is created
 */

// ============================================================================
// CALLABLE FUNCTIONS
// ============================================================================

/**
 * sayHello - Basic greeting function
 * Demonstrates simple callable Cloud Function pattern
 * 
 * @param {string} data.name - User's name
 * @returns {Object} {message, timestamp}
 */
exports.sayHello = functions.https.onCall(async (data, context) => {
  // Validate input
  if (!data.name || typeof data.name !== 'string') {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Name parameter is required and must be a string'
    );
  }

  console.log(`sayHello called with name: ${data.name}`);

  try {
    const message = `Hello, ${data.name}! Welcome to Farm2Home.`;

    // Log to Firebase Console
    console.info('sayHello response', {
      name: data.name,
      message: message,
      timestamp: new Date().toISOString(),
    });

    return {
      message: message,
      timestamp: new Date().toISOString(),
      success: true,
    };
  } catch (error) {
    console.error('Error in sayHello:', error);
    throw new functions.https.HttpsError('internal', 'Failed to process greeting');
  }
});

/**
 * calculateSum - Server-side arithmetic function
 * Demonstrates parameter handling and computation
 * 
 * @param {number} data.a - First number
 * @param {number} data.b - Second number
 * @returns {Object} {a, b, sum, timestamp}
 */
exports.calculateSum = functions.https.onCall(async (data, context) => {
  // Validate inputs
  if (typeof data.a !== 'number' || typeof data.b !== 'number') {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Both a and b must be numbers'
    );
  }

  console.log(`calculateSum called with a: ${data.a}, b: ${data.b}`);

  try {
    const sum = data.a + data.b;

    console.info('calculateSum response', {
      a: data.a,
      b: data.b,
      sum: sum,
      timestamp: new Date().toISOString(),
    });

    return {
      a: data.a,
      b: data.b,
      sum: sum,
      timestamp: new Date().toISOString(),
      success: true,
    };
  } catch (error) {
    console.error('Error in calculateSum:', error);
    throw new functions.https.HttpsError('internal', 'Failed to calculate sum');
  }
});

/**
 * getServerTime - Retrieve server's current timestamp
 * Demonstrates no-parameter function
 * 
 * @returns {Object} {timestamp, unixTime}
 */
exports.getServerTime = functions.https.onCall(async (data, context) => {
  console.log('getServerTime called');

  try {
    const now = new Date();

    console.info('getServerTime response', {
      timestamp: now.toISOString(),
      unixTime: Math.floor(now.getTime() / 1000),
    });

    return {
      timestamp: now.toISOString(),
      unixTime: Math.floor(now.getTime() / 1000),
      success: true,
    };
  } catch (error) {
    console.error('Error in getServerTime:', error);
    throw new functions.https.HttpsError('internal', 'Failed to get server time');
  }
});

/**
 * sendWelcomeMessage - Send welcome notification to new user
 * Demonstrates database operations and notifications
 * 
 * @param {string} data.userId - Firebase user ID
 * @param {string} data.email - User email
 * @param {string} data.userName - Display name
 * @returns {Object} {success, message, timestamp}
 */
exports.sendWelcomeMessage = functions.https.onCall(async (data, context) => {
  // Validate inputs
  if (!data.userId || !data.email || !data.userName) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'userId, email, and userName are required'
    );
  }

  console.log(`sendWelcomeMessage called for user: ${data.userId}`);

  try {
    // In production, this would send an actual email via Mailgun, SendGrid, etc.
    // For demo, we'll just log and store in Firestore

    // Create notification document
    await db.collection('notifications').add({
      userId: data.userId,
      type: 'welcome',
      email: data.email,
      userName: data.userName,
      message: `Welcome to Farm2Home, ${data.userName}! We're excited to have you.`,
      read: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.info('sendWelcomeMessage notification created', {
      userId: data.userId,
      email: data.email,
      userName: data.userName,
    });

    return {
      success: true,
      message: `Welcome email prepared for ${data.email}`,
      timestamp: new Date().toISOString(),
    };
  } catch (error) {
    console.error('Error in sendWelcomeMessage:', error);
    throw new functions.https.HttpsError('internal', 'Failed to send welcome message');
  }
});

/**
 * processImage - Process images with filters (placeholder)
 * Demonstrates external API integration pattern
 * 
 * @param {string} data.imageUrl - URL of image to process
 * @param {string} data.filter - Filter name (blur, grayscale, enhance)
 * @returns {Object} {success, processedImageUrl, filter, processingTime}
 */
exports.processImage = functions.https.onCall(async (data, context) => {
  // Validate inputs
  if (!data.imageUrl || !data.filter) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'imageUrl and filter are required'
    );
  }

  const validFilters = ['blur', 'grayscale', 'enhance', 'sharpen'];
  if (!validFilters.includes(data.filter)) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      `Filter must be one of: ${validFilters.join(', ')}`
    );
  }

  console.log(`processImage called with filter: ${data.filter}`);

  const startTime = Date.now();

  try {
    // In production, this would:
    // 1. Download image from URL
    // 2. Apply image processing (using ImageMagick, TensorFlow, etc.)
    // 3. Upload processed image to Cloud Storage
    // 4. Return new URL

    // For demo, we'll simulate processing with a delay
    await new Promise((resolve) => setTimeout(resolve, 500));

    const processingTime = Date.now() - startTime;

    // Simulated processed image URL
    const processedImageUrl = `${data.imageUrl}?filter=${data.filter}&processed=true`;

    console.info('processImage response', {
      originalUrl: data.imageUrl,
      filter: data.filter,
      processingTime: processingTime,
      processedUrl: processedImageUrl,
    });

    return {
      success: true,
      processedImageUrl: processedImageUrl,
      filter: data.filter,
      processingTime: processingTime,
      timestamp: new Date().toISOString(),
    };
  } catch (error) {
    console.error('Error in processImage:', error);
    throw new functions.https.HttpsError('internal', 'Failed to process image');
  }
});

// ============================================================================
// EVENT-TRIGGERED FUNCTIONS
// ============================================================================

/**
 * onUserCreated - Triggered when a new user document is created in Firestore
 * Performs initialization tasks for new users
 * 
 * Trigger: Firestore - users collection - onCreate
 */
exports.onUserCreated = functions.firestore
  .document('users/{userId}')
  .onCreate(async (snap, context) => {
    const userId = context.params.userId;
    const userData = snap.data();

    console.log(`onUserCreated triggered for user: ${userId}`);

    try {
      // Create user preferences document
      await db.collection('users').doc(userId).collection('preferences').doc('settings').set({
        theme: 'light',
        notifications: true,
        language: 'en',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Create empty cart
      await db.collection('users').doc(userId).collection('cart').doc('metadata').set({
        itemCount: 0,
        totalPrice: 0,
        lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Log analytics
      await db.collection('analytics').add({
        event: 'user_created',
        userId: userId,
        email: userData.email,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      });

      console.info('User initialization completed', {
        userId: userId,
        email: userData.email,
        timestamp: new Date().toISOString(),
      });

      // Return for logging purposes
      return {
        success: true,
        message: `User ${userId} initialized`,
      };
    } catch (error) {
      console.error('Error in onUserCreated:', error);
      // Don't throw - continue execution
      return {
        success: false,
        error: error.message,
      };
    }
  });

/**
 * onOrderCreated - Triggered when order is created
 * Performs order fulfillment tasks
 * 
 * Trigger: Firestore - orders collection - onCreate
 */
exports.onOrderCreated = functions.firestore
  .document('orders/{orderId}')
  .onCreate(async (snap, context) => {
    const orderId = context.params.orderId;
    const orderData = snap.data();

    console.log(`onOrderCreated triggered for order: ${orderId}`);

    try {
      // Update product stock
      const batch = db.batch();

      for (const item of orderData.items || []) {
        const productRef = db.collection('products').doc(item.productId);
        batch.update(productRef, {
          stock: admin.firestore.FieldValue.increment(-item.quantity),
        });
      }

      await batch.commit();

      // Create order notification
      await db.collection('notifications').add({
        orderId: orderId,
        userId: orderData.userId,
        type: 'order_confirmed',
        message: `Your order #${orderId} has been confirmed`,
        data: {
          total: orderData.total,
          itemCount: orderData.items.length,
        },
        read: false,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      console.info('Order processing completed', {
        orderId: orderId,
        userId: orderData.userId,
        itemCount: orderData.items.length,
      });

      return {
        success: true,
        message: `Order ${orderId} processed`,
      };
    } catch (error) {
      console.error('Error in onOrderCreated:', error);
      return {
        success: false,
        error: error.message,
      };
    }
  });

// ============================================================================
// SCHEDULED FUNCTIONS (Optional)
// ============================================================================

/**
 * cleanupOldNotifications - Scheduled function that runs daily
 * Removes notifications older than 30 days
 * 
 * Schedule: Every day at 2 AM
 */
exports.cleanupOldNotifications = functions.pubsub
  .schedule('every day 02:00')
  .timeZone('UTC')
  .onRun(async (context) => {
    console.log('cleanupOldNotifications scheduled function started');

    try {
      const thirtyDaysAgo = new Date();
      thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

      const snapshot = await db
        .collection('notifications')
        .where('createdAt', '<', thirtyDaysAgo)
        .limit(1000)
        .get();

      const batch = db.batch();
      let deletedCount = 0;

      snapshot.docs.forEach((doc) => {
        batch.delete(doc.ref);
        deletedCount++;
      });

      if (deletedCount > 0) {
        await batch.commit();
      }

      console.info('Cleanup completed', {
        deletedCount: deletedCount,
        timestamp: new Date().toISOString(),
      });

      return {
        success: true,
        deletedCount: deletedCount,
      };
    } catch (error) {
      console.error('Error in cleanupOldNotifications:', error);
      return {
        success: false,
        error: error.message,
      };
    }
  });

// ============================================================================
// HELPER FUNCTIONS
// ============================================================================

/**
 * Global error handler middleware
 * Logs all function errors to console for Firebase Console visibility
 */
process.on('uncaughtException', (error) => {
  console.error('Uncaught exception:', error);
});

/**
 * Log function version info
 */
console.log('Farm2Home Cloud Functions initialized');
console.log('Available callable functions:');
console.log('  - sayHello(name)');
console.log('  - calculateSum(a, b)');
console.log('  - getServerTime()');
console.log('  - sendWelcomeMessage(userId, email, userName)');
console.log('  - processImage(imageUrl, filter)');
console.log('Available triggers:');
console.log('  - onUserCreated (users/{userId} onCreate)');
console.log('  - onOrderCreated (orders/{orderId} onCreate)');
console.log('  - cleanupOldNotifications (daily at 2 AM UTC)');
