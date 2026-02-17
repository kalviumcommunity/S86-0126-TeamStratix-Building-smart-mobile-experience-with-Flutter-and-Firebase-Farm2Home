import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/splash_screen.dart';

/// Wrapper widget that ensures only customers can access wrapped widgets
class CustomerOnlyWrapper extends StatelessWidget {
  final Widget child;

  const CustomerOnlyWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.currentUser;
        
        if (user == null || !user.isCustomer) {
          return const SplashScreen();
        }
        
        return child;
      },
    );
  }
}

/// Wrapper widget that ensures only farmers can access wrapped widgets
class FarmerOnlyWrapper extends StatelessWidget {
  final Widget child;

  const FarmerOnlyWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.currentUser;
        
        if (user == null || !user.isFarmer) {
          return const SplashScreen();
        }
        
        return child;
      },
    );
  }
}