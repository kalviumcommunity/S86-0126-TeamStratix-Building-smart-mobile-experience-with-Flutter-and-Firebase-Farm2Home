import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../models/status_update_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============ User Operations ============

  // Get user by ID
  Future<UserModel?> getUserById(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromSnapshot(doc);
    } catch (e) {
      throw 'Failed to fetch user data: ${e.toString()}';
    }
  }

  // Get all farmers
  Future<List<UserModel>> getFarmers() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'farmer')
          .get();

      return snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
    } catch (e) {
      throw 'Failed to fetch farmers: ${e.toString()}';
    }
  }

  // ============ Order Operations ============

  // Create a new order
  Future<String> createOrder(OrderModel order) async {
    try {
      // Generate a new document ID first
      final docRef = _firestore.collection('orders').doc();
      
      // Create order map with the generated ID
      final orderData = order.toMap();
      orderData['orderId'] = docRef.id;
      
      // Set the document with the ID included
      await docRef.set(orderData);

      // Create initial status update
      await createStatusUpdate(
        orderId: docRef.id,
        status: order.status,
        notes: 'Order placed successfully',
      );

      return docRef.id;
    } catch (e) {
      throw 'Failed to create order: ${e.toString()}';
    }
  }

  // Get orders by customer ID
  Stream<List<OrderModel>> getOrdersByCustomer(String customerId) {
    return _firestore
        .collection('orders')
        .where('customerId', isEqualTo: customerId)
        .snapshots()
        .map((snapshot) {
          final orders = snapshot.docs.map((doc) => OrderModel.fromSnapshot(doc)).toList();
          orders.sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Sort by timestamp desc
          return orders;
        });
  }

  // Get orders by farmer ID
  Stream<List<OrderModel>> getOrdersByFarmer(String farmerId) {
    return _firestore
        .collection('orders')
        .where('farmerId', isEqualTo: farmerId)
        .snapshots()
        .map((snapshot) {
          final orders = snapshot.docs.map((doc) => OrderModel.fromSnapshot(doc)).toList();
          orders.sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Sort by timestamp desc
          return orders;
        });
  }

  // Get pending orders for farmer
  Stream<List<OrderModel>> getPendingOrdersByFarmer(String farmerId) {
    return _firestore
        .collection('orders')
        .where('farmerId', isEqualTo: farmerId)
        .where('status', whereIn: ['Received', 'Harvesting', 'Packed', 'Out for Delivery'])
        .snapshots()
        .map((snapshot) {
          final orders = snapshot.docs.map((doc) => OrderModel.fromSnapshot(doc)).toList();
          orders.sort((a, b) => a.timestamp.compareTo(b.timestamp)); // Sort by timestamp asc
          return orders;
        });
  }

  // Get delivered orders for farmer
  Stream<List<OrderModel>> getDeliveredOrdersByFarmer(String farmerId) {
    return _firestore
        .collection('orders')
        .where('farmerId', isEqualTo: farmerId)
        .where('status', isEqualTo: 'Delivered')
        .snapshots()
        .map((snapshot) {
          final orders = snapshot.docs.map((doc) => OrderModel.fromSnapshot(doc)).toList();
          orders.sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Sort by timestamp desc (newest first)
          return orders;
        });
  }

  // Get order by ID
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final doc = await _firestore.collection('orders').doc(orderId).get();
      if (!doc.exists) return null;
      return OrderModel.fromSnapshot(doc);
    } catch (e) {
      throw 'Failed to fetch order: ${e.toString()}';
    }
  }

  // Stream single order
  Stream<OrderModel?> streamOrder(String orderId) {
    return _firestore
        .collection('orders')
        .doc(orderId)
        .snapshots()
        .map((doc) => doc.exists ? OrderModel.fromSnapshot(doc) : null);
  }

  // Update order status
  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
    String? notes,
  }) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status,
      });

      // Create status update record
      await createStatusUpdate(
        orderId: orderId,
        status: status,
        notes: notes,
      );
    } catch (e) {
      throw 'Failed to update order status: ${e.toString()}';
    }
  }

  // ============ Status Update Operations ============

  // Create status update
  Future<void> createStatusUpdate({
    required String orderId,
    required String status,
    String? notes,
  }) async {
    try {
      // Generate a new document ID first
      final docRef = _firestore.collection('statusUpdates').doc();
      
      final statusUpdate = StatusUpdateModel(
        updateId: docRef.id,
        orderId: orderId,
        status: status,
        updatedAt: DateTime.now(),
        notes: notes,
      );

      // Set the document with the ID included
      await docRef.set(statusUpdate.toMap());
    } catch (e) {
      throw 'Failed to create status update: ${e.toString()}';
    }
  }

  // Get status updates for an order
  Stream<List<StatusUpdateModel>> getStatusUpdates(String orderId) {
    return _firestore
        .collection('statusUpdates')
        .where('orderId', isEqualTo: orderId)
        .orderBy('updatedAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StatusUpdateModel.fromSnapshot(doc))
            .toList());
  }

  // Get latest status updates for an order
  Future<List<StatusUpdateModel>> getLatestStatusUpdates(String orderId) async {
    try {
      final snapshot = await _firestore
          .collection('statusUpdates')
          .where('orderId', isEqualTo: orderId)
          .orderBy('updatedAt', descending: false)
          .get();

      return snapshot.docs
          .map((doc) => StatusUpdateModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw 'Failed to fetch status updates: ${e.toString()}';
    }
  }

  // ============ Statistics ============

  // Get order count by customer
  Future<int> getCustomerOrderCount(String customerId) async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('customerId', isEqualTo: customerId)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Get order count by farmer
  Future<int> getFarmerOrderCount(String farmerId) async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('farmerId', isEqualTo: farmerId)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Get pending order count for farmer
  Future<int> getPendingOrderCount(String farmerId) async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('farmerId', isEqualTo: farmerId)
          .where('status', whereIn: ['Received', 'Harvesting', 'Packed', 'Out for Delivery'])
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Get delivered order count for farmer
  Future<int> getDeliveredOrderCount(String farmerId) async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('farmerId', isEqualTo: farmerId)
          .where('status', isEqualTo: 'Delivered')
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }
}
