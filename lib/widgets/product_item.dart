import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/dataBase/AppCubit.dart';
import 'package:shop_app/dataBase/appStates.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final Map dataMap;
  final int index;

  ProductItem(this.dataMap, this.index);

  @override
  Widget build(BuildContext context) {
    String isFavorite = dataMap['isFavorite'];
    return BlocConsumer<AppCubit, AppStates>(
        builder: (ctx, state) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: GridTile(
              child: GestureDetector(
                child: Image.network(
                  dataMap['imageUrl'],
                  fit: BoxFit.cover,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ProductDetailScreen.routeName,
                    arguments: dataMap,
                  );
                },
              ),
              footer: GridTileBar(
                leading: IconButton(
                  icon: Icon(dataMap['isFavorite'] == 'true'
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    AppCubit.get(context)
                        .toggleFavoriteStatus(isFavorite, dataMap['id']);
                  },
                ),
                backgroundColor: Colors.black87,
                title: Text(
                  dataMap['title'],
                  textAlign: TextAlign.center,
                ),
                trailing: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    AppCubit.get(context).addItem(
                        dataMap['id'], dataMap['price'], dataMap['title']);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Item added to chart',
                        textAlign: TextAlign.center,
                      ),
                      duration: Duration(
                        seconds: 3,
                      ),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          AppCubit.get(context).removeSingleItem(dataMap['id']);
                        },
                        textColor: Theme.of(context).primaryColor,
                      ),
                    ));
                  },
                ),
              ),
            ),
          );
        },
        listener: (ctx, state) {});
  }
}
