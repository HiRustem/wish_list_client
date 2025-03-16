import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish_list_client/components/user_card.dart';
import 'package:wish_list_client/models/user_model.dart';
import 'package:wish_list_client/providers/user_provider.dart';
import 'package:wish_list_client/services/user_service.dart';

class FollowingScreen extends StatefulWidget {
  final String userId;

  FollowingScreen({required this.userId});

  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  final UserService _userService = UserService();
  List<UserModel> _following = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFollowing();
  }

  Future<void> _loadFollowing() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final following = await _userService.getFollowing(widget.userId);
      setState(() {
        _following = following;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load following: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.user;

    return Scaffold(
      appBar: AppBar(title: Text('Following')),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _following.length,
                itemBuilder: (context, index) {
                  final followingUser = _following[index];
                  final isFollowed = _following.any(
                    (user) => user.id == currentUser?.id,
                  );

                  return UserCard(
                    user: followingUser,
                    isFollowed: isFollowed,
                    onFollowToggle: () async {
                      try {
                        // Логика подписки/отписки
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to toggle subscription: $e'),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
    );
  }
}
