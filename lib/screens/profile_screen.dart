import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish_list_client/components/custom_app_bar.dart';
import 'package:wish_list_client/components/user_avatar.dart';
import 'package:wish_list_client/components/wish_card.dart';
import 'package:wish_list_client/models/user_model.dart';
import 'package:wish_list_client/providers/user_provider.dart';
import 'package:wish_list_client/providers/wish_provider.dart';
import 'package:wish_list_client/providers/wishlist_provider.dart';
import 'package:wish_list_client/screens/followers_screen.dart';
import 'package:wish_list_client/screens/following_screen.dart';
import 'package:wish_list_client/screens/login_screen.dart';
import 'package:wish_list_client/services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;

  const ProfileScreen({super.key, this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<void> _loadDataFuture;
  UserModel? _user;
  UserStats? _userStats;
  final UserService _userService = UserService();
  bool _isFollowing = false;
  bool _isLoadingFollow = false;

  @override
  void initState() {
    super.initState();
    _loadDataFuture = _loadData();
  }

  Future<void> _loadData() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = widget.userId ?? userProvider.user!.id;

      // Загружаем данные параллельно
      final futures = [
        _loadUser(userId, userProvider),
        _loadUserStats(userId),
        _loadWishlists(userId),
      ];

      await Future.wait(futures);

      if (widget.userId != null && userProvider.user != null) {
        _isFollowing = await _userService.isFollowing(
          userProvider.user!.id,
          userId,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load profile!')));
    }
  }

  Future<void> _loadUser(String userId, UserProvider userProvider) async {
    if (widget.userId == null) {
      _user = userProvider.user;
    } else {
      _user = await _userService.getUserById(userId);
    }
  }

  Future<void> _loadUserStats(String userId) async {
    _userStats = await _userService.getFollowsCount(userId);
  }

  Future<void> _loadWishlists(String userId) async {
    final wishlistProvider = Provider.of<WishlistProvider>(
      context,
      listen: false,
    );
    await wishlistProvider.loadWishlists(userId);

    final wishProvider = Provider.of<WishProvider>(context, listen: false);
    for (final wishlist in wishlistProvider.getWishlistsByUser(userId)) {
      await wishProvider.loadWishes(wishlist.id);
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
    final wishProvider = Provider.of<WishProvider>(context);

    final userId = widget.userId ?? currentUser?.id;

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
            } else if (_user == null || _userStats == null || userId == null) {
              return Center(child: Text('No data available'));
            } else {
              final wishlists = wishlistProvider.getWishlistsByUser(userId);

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
                        wishlists.isEmpty
                            ? Center(child: Text('No wishlists available'))
                            : ListView.builder(
                              itemCount: wishlists.length,
                              itemBuilder: (context, index) {
                                final wishlist = wishlists[index];
                                final wishes = wishProvider.getWishesByWishlist(
                                  wishlist.id,
                                );

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
                                      itemCount: wishes.length,
                                      itemBuilder: (context, index) {
                                        final wish = wishes[index];
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
