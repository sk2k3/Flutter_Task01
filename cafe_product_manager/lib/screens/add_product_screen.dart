import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class AddProductScreen extends StatefulWidget {
  static const routeName = '/add-product';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String description = '';
  String imageUrl = '';
  double price = 0.0;

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newProduct = Product(
        name: name,
        description: description,
        price: price,
        imageUrl: imageUrl,
      );
      await Provider.of<ProductProvider>(context, listen: false).addProduct(newProduct);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (value) => name = value!,
                validator: (value) => value!.isEmpty ? 'Enter a name' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => description = value!,
                validator: (value) => value!.isEmpty ? 'Enter a description' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onSaved: (value) => price = double.parse(value!),
                validator: (value) => value!.isEmpty ? 'Enter a price' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Image URL'),
                onSaved: (value) => imageUrl = value!,
                validator: (value) => value!.isEmpty ? 'Enter an image URL' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: const Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}