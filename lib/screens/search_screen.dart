import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish_list_client/components/user_card.dart';
import 'package:wish_list_client/models/user_model.dart';
import 'package:wish_list_client/providers/user_provider.dart';
import 'package:wish_list_client/services/user_service.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final UserService _userService = UserService();
  List<UserModel> _searchResults = [];
  bool _isLoading = false;

  void _searchUsers(String nickname) async {
    if (nickname.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final searchResults = await _userService.getUsersByNickname(nickname);
      setState(() {
        _searchResults = searchResults;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to search users: $e')));
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
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            icon: Icon(Icons.search),
            hintText: 'Search by nickname...',
            border: InputBorder.none,
          ),
          onChanged: _searchUsers,
        ),
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator()) // Лоадер по центру
              : _searchResults.isEmpty
              ? Center(
                child: Text('No users found'),
              ) // Сообщение, если нет результатов
              : ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final searchUser = _searchResults[index];

                  return FutureBuilder<bool>(
                    future: _userService.isFollowing(
                      currentUser!.id,
                      searchUser.id,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return ListTile(
                          title: Text(searchUser.nickname ?? 'Unknown User'),
                          subtitle: Text('Error loading follow status'),
                        );
                      } else {
                        final isFollowed = snapshot.data ?? false;

                        return UserCard(
                          user: searchUser,
                          isFollowed: isFollowed,
                          onFollowToggle: () async {
                            try {
                              if (isFollowed) {
                                await _userService.unfollowUser(
                                  currentUser.id,
                                  searchUser.id,
                                );
                              } else {
                                await _userService.followUser(
                                  currentUser.id,
                                  searchUser.id,
                                );
                              }
                              setState(() {});
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to toggle subscription: $e',
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      }
                    },
                  );
                },
              ),
    );
  }
}
