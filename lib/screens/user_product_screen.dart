import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/dataBase/AppCubit.dart';
import 'package:shop_app/dataBase/appStates.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        final productData = AppCubit.get(context).productData;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Your Products'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName);
                },
              ),
            ],
          ),
          drawer: AppDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: productData.length,
              itemBuilder: (ctx, index) => Column(
                children: [
                  UserProductItem(
                    productData[index]['title'],
                    productData[index]['description'],
                    productData[index]['price'],
                    productData[index]['imageUrl'],
                    productData[index]['id'],
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
