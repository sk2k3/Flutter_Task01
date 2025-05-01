import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/product_provider.dart';
import './screens/home_screen.dart';
import './screens/add_product_screen.dart';
import './screens/product_detail_screen.dart';

void main() {
  runApp(const CafeProductManager());
}

class CafeProductManager extends StatelessWidget {
  const CafeProductManager({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cafe Product Manager',
        theme: ThemeData(
          primarySwatch: Colors.brown,
          fontFamily: 'Taffy',
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => const HomeScreen(),
          AddProductScreen.routeName: (ctx) => const AddProductScreen(),
          ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
        },
      ),
    );
  }
}
