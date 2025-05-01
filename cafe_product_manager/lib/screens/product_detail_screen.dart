import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late Product _product;
  String name = '';
  String description = '';
  String imageUrl = '';
  double price = 0.0;

  void _saveForm(String id) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final updatedProduct = Product(
        id: id,
        name: name,
        description: description,
        price: price,
        imageUrl: imageUrl,
      );
      await Provider.of<ProductProvider>(context, listen: false).updateProduct(id, updatedProduct);
      Navigator.of(context).pop();
    }
  }

  void _deleteProduct(String id) async {
    await Provider.of<ProductProvider>(context, listen: false).deleteProduct(id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    _product = Provider.of<ProductProvider>(context).getProductById(productId)!;
    name = _product.name;
    description = _product.description;
    price = _product.price;
    imageUrl = _product.imageUrl;

    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => description = value!,
              ),
              TextFormField(
                initialValue: price.toString(),
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onSaved: (value) => price = double.parse(value!),
              ),
              TextFormField(
                initialValue: imageUrl,
                decoration: const InputDecoration(labelText: 'Image URL'),
                onSaved: (value) => imageUrl = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _saveForm(_product.id),
                child: const Text('Update Product'),
              ),
              TextButton(
                onPressed: () => _deleteProduct(_product.id),
                child: const Text('Delete Product', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
