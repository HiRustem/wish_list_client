import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish_list_client/components/custom_app_bar.dart';
import 'package:wish_list_client/screens/login_screen.dart';
import 'package:wish_list_client/screens/wishlist_selection_screen.dart';
import '../providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.logout();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Logout failed')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _createNewPost() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WishlistSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Home',
        showBackButton: false,
        showAvatar: false,
        actions: [IconButton(icon: Icon(Icons.add), onPressed: _createNewPost)],
      ),
      body: Center(
        child:
            user != null
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Email: ${user.email}'),
                    if (user.nickname != null)
                      Text('Nickname: ${user.nickname}'),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _logout,
                      child:
                          _isLoading
                              ? CircularProgressIndicator()
                              : Text('Logout'),
                    ),
                  ],
                )
                : Text('No user data'),
      ),
    );
  }
}
