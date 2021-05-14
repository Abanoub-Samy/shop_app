import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/dataBase/AppCubit.dart';
import 'package:shop_app/dataBase/appStates.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavoritesOnly;

  ProductGrid(this.showFavoritesOnly);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (ctx, state) {
          var productsData = AppCubit.get(context).productData;
          // final products = showFavoritesOnly
          //     ? productsData = AppCubit.get(context).isFavorite
          //     : productsData = AppCubit.get(context).productData;
          return productsData.isEmpty
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
                  itemBuilder: (ctx, i) => ProductItem(productsData[i], i),
                  itemCount: productsData.length,
                );
        },
        listener: (ctx, state) {});
  }
}
