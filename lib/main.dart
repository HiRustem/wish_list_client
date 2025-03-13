import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:wish_list_client/providers/user_provider.dart';
import 'package:wish_list_client/screens/home_screen.dart';
import 'package:wish_list_client/screens/login_screen.dart';
import 'package:wish_list_client/screens/splash_screen.dart';
import 'package:wish_list_client/utils/shared_prefs.dart';

void main() async {
  await dotenv.load(fileName: '.env');

  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wishlist',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder(
        future: _checkTokenAndLoadUser(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else {
            return snapshot.data == true ? HomeScreen() : LoginScreen();
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
