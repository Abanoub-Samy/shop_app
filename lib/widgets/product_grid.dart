import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavoritesOnly;

  ProductGrid(this.showFavoritesOnly);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showFavoritesOnly ? productsData.favorites : productsData.items;
    return productsData.items.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.not_interested_rounded,
                  size: 200,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('There is no product yet !'),
              ],
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (ctx, i) => ChangeNotifierProvider(
                create: (c) => products[i],
                child: ProductItem(
                    // products[i].id,
                    // products[i].title,
                    // products[i].imageUrl
                    )),
            itemCount: products.length,
          );
  }
}
