import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'driver_dashboard.dart';
import 'get_started.dart';
import 'models/user_model.dart';
import 'passenger_dashboard.dart';
import 'services/auth_service.dart';

/// Routes the user to the correct screen based on their Firebase Auth state
/// and Firestore profile (passenger vs driver).
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const _LoadingScreen();
        }
        final user = snap.data;
        if (user == null) {
          return const GetStartedScreen();
        }
        return FutureBuilder<UserModel?>(
          future: AuthService.instance.getCurrentProfile(),
          builder: (context, profileSnap) {
            if (profileSnap.connectionState == ConnectionState.waiting) {
              return const _LoadingScreen();
            }
            final profile = profileSnap.data;
            if (profile == null) {
              // Profile missing — fall back to onboarding.
              return const GetStartedScreen();
            }
            return profile.role == UserRole.driver
                ? const DriverDashboard()
                : const PassengerDashboard();
          },
        );
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
