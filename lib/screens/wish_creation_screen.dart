import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wish_list_client/models/wish_model.dart';
import 'package:wish_list_client/providers/wish_provider.dart';
import 'package:wish_list_client/screens/main_screen.dart';
import 'package:wish_list_client/screens/profile_screen.dart';

class WishCreationScreen extends StatefulWidget {
  final String wishlistId;

  WishCreationScreen({required this.wishlistId});

  @override
  _WishCreationScreenState createState() => _WishCreationScreenState();
}

class _WishCreationScreenState extends State<WishCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _linkController = TextEditingController();
  WishType _type = WishType.GENERAL;

  @override
  Widget build(BuildContext context) {
    final wishProvider = Provider.of<WishProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Create New Wish')),
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
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              TextFormField(
                controller: _linkController,
                decoration: InputDecoration(labelText: 'Link'),
              ),
              DropdownButtonFormField<WishType>(
                value: _type,
                onChanged: (value) {
                  setState(() {
                    _type = value!;
                  });
                },
                items:
                    WishType.values
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.name),
                          ),
                        )
                        .toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await wishProvider.createWish(
                        wishlistId: widget.wishlistId,
                        title: _titleController.text,
                        description: _descriptionController.text,
                        imageUrl: _imageUrlController.text,
                        link: _linkController.text,
                        type: _type,
                      );

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainScreen(currentIndex: 2),
                        ),
                        (route) => false,
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to create wish!')),
                      );
                    }
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
