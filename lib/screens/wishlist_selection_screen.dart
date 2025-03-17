import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish_list_client/providers/user_provider.dart';
import 'package:wish_list_client/providers/wishlist_provider.dart';
import 'package:wish_list_client/screens/wish_creation_screen.dart';
import 'package:wish_list_client/screens/wishlist_creation_screen.dart';

class WishlistSelectionScreen extends StatefulWidget {
  @override
  _WishlistSelectionScreenState createState() =>
      _WishlistSelectionScreenState();
}

class _WishlistSelectionScreenState extends State<WishlistSelectionScreen> {
  String? _selectedWishlistId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadWishlists();
  }

  Future<void> _loadWishlists() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final wishlistProvider = Provider.of<WishlistProvider>(
      context,
      listen: false,
    );

    if (userProvider.user == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await wishlistProvider.loadWishlists(userProvider.user!.id);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load wishlists: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(title: Text('Select Wishlist')),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: wishlistProvider.wishlists.length,
                        itemBuilder: (context, index) {
                          final wishlist = wishlistProvider.wishlists[index];
                          return ListTile(
                            title: Text(wishlist.title),
                            trailing:
                                _selectedWishlistId == wishlist.id
                                    ? Icon(Icons.check)
                                    : null,
                            onTap: () {
                              setState(() {
                                _selectedWishlistId = wishlist.id;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (user == null) return;

                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WishlistCreationScreen(),
                          ),
                        );

                        if (result == true) {
                          await _loadWishlists();
                        }
                      },
                      child: Text('Create New Wishlist'),
                    ),
                    SizedBox(height: 16.0),
                    if (_selectedWishlistId != null)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => WishCreationScreen(
                                    wishlistId: _selectedWishlistId!,
                                  ),
                            ),
                          );
                        },
                        child: Text('Create Wish in Selected List'),
                      ),
                  ],
                ),
              ),
    );
  }
}
