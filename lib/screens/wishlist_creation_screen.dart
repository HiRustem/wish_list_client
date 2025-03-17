import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish_list_client/providers/user_provider.dart';
import 'package:wish_list_client/providers/wishlist_provider.dart';

class WishlistCreationScreen extends StatefulWidget {
  @override
  _WishlistCreationScreenState createState() => _WishlistCreationScreenState();
}

class _WishlistCreationScreenState extends State<WishlistCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(title: Text('Create New Wishlist')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (user == null) return;

                  if (_formKey.currentState!.validate()) {
                    await wishlistProvider.createWishlist(
                      user.id,
                      _titleController.text,
                    );

                    Navigator.pop(context, true);
                  }
                },
                child: Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
