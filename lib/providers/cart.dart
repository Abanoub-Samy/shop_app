// import 'package:bloc/bloc.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:shop_app/dataBase/appStates.dart';
//
// class Cart {
//   Map<String, CartItem> _items = {};
//
//
//   Map<String, CartItem> get items => _items;
//
//   int get itemCount {
//     return _items.length;
//   }
//
//   void addItem(
//     String productId,
//     double price,
//     String title,
//   ) {
//     if (_items.containsKey(productId)) {
//       _items.update(
//           productId,
//           (value) => CartItem(
//                 id: value.id,
//                 price: value.price,
//                 title: value.title,
//                 quantity: value.quantity + 1,
//               ));
//     } else {
//       _items.putIfAbsent(
//           productId,
//           () => CartItem(
//               id: DateTime.now().toString(),
//               title: title,
//               quantity: 1,
//               price: price));
//     }
//   }
//
//   void removeItem(String productId) {
//     _items.remove(productId);
//   }
//
//   double get totalAmount {
//     var total = 0.0;
//     _items.forEach((key, value) {
//       total += value.price * value.quantity;
//     });
//     return total;
//   }
//
//   void clear() {
//     _items = {};
//   }
//
//   void removeSingleItem(String productId) {
//     if (!_items.containsKey(productId)) {
//       return;
//     }
//     if (_items[productId].quantity > 1) {
//       _items.update(
//           productId,
//           (value) => CartItem(
//                 id: value.id,
//                 title: value.title,
//                 quantity: value.quantity - 1,
//                 price: value.price,
//               ));
//     } else {
//       _items.remove(productId);
//     }
//   }
// }
//
// class CartItem {
//   final String id;
//
//   final String title;
//   final int quantity;
//
//   final double price;
//
//   CartItem(
//       {@required this.id,
//       @required this.title,
//       @required this.quantity,
//       @required this.price});
// }
