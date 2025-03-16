import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish_list_client/components/user_card.dart';
import 'package:wish_list_client/models/user_model.dart';
import 'package:wish_list_client/providers/user_provider.dart';
import 'package:wish_list_client/services/user_service.dart';

class FollowersScreen extends StatefulWidget {
  final String userId;

  FollowersScreen({required this.userId});

  @override
  _FollowersScreenState createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  final UserService _userService = UserService();
  List<UserModel> _followers = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFollowers();
  }

  Future<void> _loadFollowers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final followers = await _userService.getFollowers(widget.userId);
      setState(() {
        _followers = followers;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load followers: $e')));
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
      appBar: AppBar(title: Text('Followers')),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _followers.length,
                itemBuilder: (context, index) {
                  final follower = _followers[index];
                  final isFollowed = _followers.any(
                    (user) => user.id == currentUser?.id,
                  );

                  return UserCard(
                    user: follower,
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
