// screens/product_edit_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopease/models/products_model.dart';
import 'package:shopease/provider/product_edit_provider.dart';

class ProductEditScreen extends StatefulWidget {
  final Product product;

  ProductEditScreen({required this.product});

  @override
  _ProductEditScreenState createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product.title);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
    _descriptionController =
        TextEditingController(text: widget.product.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductEditProvider(),
      child: Scaffold(
        appBar: AppBar(title: Text('Edit Product')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Consumer<ProductEditProvider>(
              builder: (context, provider, _) {
                return Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                      validator: (value) =>
                          value!.isEmpty ? 'Title is required' : null,
                    ),
                    TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(labelText: 'Price'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value!.isEmpty ? 'Price is required' : null,
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    SizedBox(height: 20),
                    provider.isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                           // screens/product_edit_screen.dart

onPressed: () async {
  if (_formKey.currentState!.validate()) {
    try {
      await provider.updateProduct(
        widget.product.id,
        _titleController.text,
        double.parse(_priceController.text),
        _descriptionController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product updated successfully!')),
      );
      Navigator.pop(context, true);  // Return true to indicate success
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update product')),
      );
    }
  }
}
,
                            child: Text('Save Changes'),
                          ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
