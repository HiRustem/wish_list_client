import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish_list_client/components/custom_app_bar.dart';
import 'package:wish_list_client/components/user_avatar.dart';
import 'package:wish_list_client/components/wish_card.dart';
import 'package:wish_list_client/models/user_model.dart';
import 'package:wish_list_client/providers/user_provider.dart';
import 'package:wish_list_client/providers/wishlist_provider.dart';
import 'package:wish_list_client/providers/wish_provider.dart';
import 'package:wish_list_client/screens/followers_screen.dart';
import 'package:wish_list_client/screens/following_screen.dart';
import 'package:wish_list_client/screens/login_screen.dart';
import 'package:wish_list_client/services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;

  ProfileScreen({this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<void> _loadDataFuture;
  UserModel? _user;
  UserStats? _userStats;
  bool _isFollowing = false;
  bool _isLoadingFollow = false;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _loadDataFuture = _loadData();
  }

  Future<void> _loadData() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = widget.userId ?? userProvider.user!.id;

      if (widget.userId == null) {
        _user = userProvider.user;
      } else {
        final currentUser = await _userService.getUserById(userId);
        _user = currentUser;

        if (userProvider.user != null) {
          _isFollowing = await _userService.isFollowing(
            userProvider.user!.id,
            userId,
          );
        }
      }

      _userStats = await _userService.getFollowsCount(userId);

      final wishlistProvider = Provider.of<WishlistProvider>(
        context,
        listen: false,
      );

      await wishlistProvider.loadWishlists(userId);

      final wishProvider = Provider.of<WishProvider>(context, listen: false);

      for (final wishlist in wishlistProvider.wishlists) {
        await wishProvider.loadWishes(wishlist.id);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load profile!')));
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _loadDataFuture = _loadData();
    });
  }

  Future<void> _toggleFollow() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.user;

    if (currentUser == null || _user == null) return;

    setState(() {
      _isLoadingFollow = true;
    });

    try {
      if (_isFollowing) {
        await _userService.unfollowUser(currentUser.id, _user!.id);
      } else {
        await _userService.followUser(currentUser.id, _user!.id);
      }
      setState(() {
        _isFollowing = !_isFollowing;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to toggle subscription: $e')),
      );
    } finally {
      setState(() {
        _isLoadingFollow = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.user;
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        showAvatar: false,
        showBackButton: false,
        actions:
            widget.userId == null
                ? [
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () async {
                      await userProvider.logout();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ]
                : null,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder(
          future: _loadDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (_user == null || _userStats == null) {
              return Center(child: Text('No data available'));
            } else {
              return Column(
                children: [
                  UserAvatar(avatar: _user?.avatar),
                  Text(_user?.nickname ?? 'Unknown User'),
                  if (widget.userId != null && currentUser != null)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child:
                          _isLoadingFollow
                              ? CircularProgressIndicator()
                              : ElevatedButton(
                                onPressed: _toggleFollow,
                                child: Text(
                                  _isFollowing ? 'Unfollow' : 'Follow',
                                ),
                              ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_user != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        FollowersScreen(userId: _user!.id),
                              ),
                            );
                          }
                        },
                        child: Column(
                          children: [
                            Text('Followers'),
                            Text(_userStats!.followersCount.toString()),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_user != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        FollowingScreen(userId: _user!.id),
                              ),
                            );
                          }
                        },
                        child: Column(
                          children: [
                            Text('Following'),
                            Text((_userStats!.followingCount.toString())),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child:
                        wishlistProvider.wishlists.isEmpty
                            ? Center(child: Text('No wishlists available'))
                            : ListView.builder(
                              itemCount: wishlistProvider.wishlists.length,
                              itemBuilder: (context, index) {
                                final wishlist =
                                    wishlistProvider.wishlists[index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Text(
                                        wishlist.title,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleLarge,
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: wishlist.wishes.length,
                                      itemBuilder: (context, index) {
                                        final wish = wishlist.wishes[index];

                                        return WishCard(wish: wish);
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
