import 'package:flutter/material.dart';
import 'package:shop_app/dataBase/AppCubit.dart' show AppCubit;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final ordersData = AppCubit.get(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, index) => OrderItem(ordersData.orders[index]),
        itemCount: ordersData.orders.length,
      ),
    );
  }
}
