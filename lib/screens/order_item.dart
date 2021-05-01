import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/order.dart' as ord;

class OrderItem extends StatelessWidget {
  final ord.OrderItem order;

  OrderItem( this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text('\$${order.amount}'),
          subtitle: Text(
            DateFormat('dd MM yyyy hh:mm').format(order.dateTime),
          ),
          trailing: IconButton(
            icon: Icon(Icons.expand_more),
            onPressed: () { },
          ),
        ),
      ),
    );
  }
}
