import 'package:cloud_functions/cloud_functions.dart';

/// Response model for Cloud Function calls
class CloudFunctionResponse {
  final dynamic data;
  final bool success;
  final String? error;

  CloudFunctionResponse({
    required this.data,
    required this.success,
    this.error,
  });

  factory CloudFunctionResponse.success(dynamic data) {
    return CloudFunctionResponse(
      data: data,
      success: true,
      error: null,
    );
  }

  factory CloudFunctionResponse.error(String error) {
    return CloudFunctionResponse(
      data: null,
      success: false,
      error: error,
    );
  }
}

/// Service for calling Cloud Functions from Flutter
class CloudFunctionService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Call the sayHello callable function
  /// Returns a greeting message
  Future<CloudFunctionResponse> callSayHello(String name) async {
    try {
      final callable = _functions.httpsCallable('sayHello');
      final result = await callable.call({'name': name});
      return CloudFunctionResponse.success(result.data);
    } on FirebaseFunctionsException catch (e) {
      return CloudFunctionResponse.error(
        'Error: ${e.code} - ${e.message}',
      );
    } catch (e) {
      return CloudFunctionResponse.error('Failed to call function: $e');
    }
  }

  /// Call the sendWelcomeMessage callable function
  /// Sends a welcome message to a user
  Future<CloudFunctionResponse> sendWelcomeMessage({
    required String userId,
    required String email,
    required String userName,
  }) async {
    try {
      final callable = _functions.httpsCallable('sendWelcomeMessage');
      final result = await callable.call({
        'userId': userId,
        'email': email,
        'userName': userName,
      });
      return CloudFunctionResponse.success(result.data);
    } on FirebaseFunctionsException catch (e) {
      return CloudFunctionResponse.error(
        'Error: ${e.code} - ${e.message}',
      );
    } catch (e) {
      return CloudFunctionResponse.error('Failed to call function: $e');
    }
  }

  /// Call the calculateSum callable function
  /// Performs server-side calculation
  Future<CloudFunctionResponse> calculateSum(int a, int b) async {
    try {
      final callable = _functions.httpsCallable('calculateSum');
      final result = await callable.call({
        'a': a,
        'b': b,
      });
      return CloudFunctionResponse.success(result.data);
    } on FirebaseFunctionsException catch (e) {
      return CloudFunctionResponse.error(
        'Error: ${e.code} - ${e.message}',
      );
    } catch (e) {
      return CloudFunctionResponse.error('Failed to call function: $e');
    }
  }

  /// Call the processImage callable function
  /// Simulates image processing on server
  Future<CloudFunctionResponse> processImage({
    required String imageUrl,
    String? filter = 'sepia',
  }) async {
    try {
      final callable = _functions.httpsCallable('processImage');
      final result = await callable.call({
        'imageUrl': imageUrl,
        'filter': filter,
      });
      return CloudFunctionResponse.success(result.data);
    } on FirebaseFunctionsException catch (e) {
      return CloudFunctionResponse.error(
        'Error: ${e.code} - ${e.message}',
      );
    } catch (e) {
      return CloudFunctionResponse.error('Failed to call function: $e');
    }
  }

  /// Call the getServerTime callable function
  /// Gets current server time from Cloud Function
  Future<CloudFunctionResponse> getServerTime() async {
    try {
      final callable = _functions.httpsCallable('getServerTime');
      final result = await callable.call();
      return CloudFunctionResponse.success(result.data);
    } on FirebaseFunctionsException catch (e) {
      return CloudFunctionResponse.error(
        'Error: ${e.code} - ${e.message}',
      );
    } catch (e) {
      return CloudFunctionResponse.error('Failed to call function: $e');
    }
  }

  /// Generic function caller for testing any callable function
  Future<CloudFunctionResponse> callFunction(
    String functionName, {
    Map<String, dynamic>? parameters,
  }) async {
    try {
      final callable = _functions.httpsCallable(functionName);
      final result = await callable.call(parameters ?? {});
      return CloudFunctionResponse.success(result.data);
    } on FirebaseFunctionsException catch (e) {
      return CloudFunctionResponse.error(
        'Error: ${e.code} - ${e.message}',
      );
    } catch (e) {
      return CloudFunctionResponse.error('Failed to call function: $e');
    }
  }

  /// Set region for Cloud Functions (for performance optimization)
  /// Default is us-central1
  void setRegion(String region) {
    _functions.useFunctionsEmulator('localhost', 5001);
    // Note: For production, use: _functions = FirebaseFunctions.instanceFor(region: 'europe-west1');
  }

  /// Get information about available functions
  Map<String, String> getAvailableFunctions() {
    return {
      'sayHello': 'Callable function that returns a greeting',
      'sendWelcomeMessage': 'Sends welcome email to new user',
      'calculateSum': 'Performs server-side arithmetic',
      'processImage': 'Applies filters to images',
      'getServerTime': 'Returns current server time',
      'onUserCreate': 'Triggered when new user is created in Firestore',
    };
  }
}
