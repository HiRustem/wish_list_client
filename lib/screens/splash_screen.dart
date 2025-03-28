import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish_list_client/providers/user_provider.dart';
import 'package:wish_list_client/screens/login_screen.dart';
import 'package:wish_list_client/screens/main_screen.dart';
import 'package:wish_list_client/utils/shared_prefs.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _checkTokenAndLoadUser(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            // Перенаправляем на MainScreen или LoginScreen с очисткой стека
            Widget nextScreen =
                snapshot.data == true ? MainScreen() : LoginScreen();
            Future.microtask(() {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => nextScreen),
                (route) => false,
              );
            });
            return Container(); // Пустой контейнер, так как навигация произойдет сразу
          }
        },
      ),
    );
  }

  Future<bool> _checkTokenAndLoadUser(BuildContext context) async {
    final token = await SharedPrefs.getToken();

    if (token == null) return false;

    try {
      await Provider.of<UserProvider>(context, listen: false).loadUser();
      return true;
    } catch (e) {
      print('Failed to load user: $e');
      return false;
    }
  }
}
