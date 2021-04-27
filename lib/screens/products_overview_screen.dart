import 'package:flutter/material.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/product_grid.dart';

class ProductsOverviewScreen extends StatelessWidget {
  final List<Products> loadedProduct = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductGrid(),
    );
  }
}
