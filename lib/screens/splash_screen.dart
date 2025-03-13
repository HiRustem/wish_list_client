import 'package:flutter/material.dart';
import 'package:wish_list_client/screens/home_screen.dart';
import 'package:wish_list_client/screens/login_screen.dart';
import 'package:wish_list_client/services/auth_service.dart';

class SplashScreen extends StatelessWidget {
  final _authService = AuthService();

  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () async {
      final isTokenValid = await _authService.checkTokenValidity();

      if (isTokenValid) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });

    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
