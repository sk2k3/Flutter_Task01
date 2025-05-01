import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import './add_product_screen.dart';
import './product_detail_screen.dart';
import 'package:lottie/lottie.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<void> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0), // light café beige
      appBar: AppBar(
        backgroundColor: const Color(0xFF6F4E37), // rich coffee brown
        centerTitle: true,
        title: const Text(
          'The Cozy Brew Room ☕',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushNamed(AddProductScreen.routeName);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: provider.fetchProducts,
        child: FutureBuilder(
          future: _productsFuture,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong!'));
            } else {
              final products = provider.products;
              return GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: products.length + 1, // Add extra card
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (ctx, i) {
                  if (i == products.length) {
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 4,
                      color: const Color(0xFFDAB894), // light brown background
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Lottie.asset(
                                'assets/animations/steam.json', // replace with your actual Lottie file path
                                height: 110,
                                repeat: true,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'New Drinks Are Brewing!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Taffy',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );

                  }

                  final product = products[i];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        ProductDetailScreen.routeName,
                        arguments: product.id,
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AspectRatio(
                            aspectRatio: 1.2,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                              child: Image.network(
                                product.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  product.description,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'Montserrat',
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Montserrat',
                                    color: Colors.brown,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
