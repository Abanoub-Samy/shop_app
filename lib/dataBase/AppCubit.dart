import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/dataBase/appStates.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  Database database;
  List<Map> productData = [];
  List<Map> cartData = [];
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  // List<Map> isFavorite = [];

  void createDatabase() {
    openDatabase('ShopApp', version: 700, onCreate: (Database db, int version) {
      print('Database created');
      db
          .execute(
              'CREATE TABLE product (id TEXT PRIMARY KEY, title TEXT,description TEXT, price Double, imageUrl TEXT,isFavorite TEXT)')
          .then((value) {
        print('table product created');
      }).catchError((onError) {
        print('Error is : $onError');
      });
      // db
      //     .execute(
      //         'CREATE TABLE cart (id TEXT PRIMARY KEY, title TEXT,quantity Double, price Double)')
      //     .then((value) {
      //   print('table cart created');
      // }).catchError((onError) {
      //   print('Error is : $onError');
      // });
    }, onOpen: (database) {
      getProductFromDatabase(database);
    }).then((value) {
      database = value;
      emit(CreateDatabase());
    });
  }

  insertProduct({
    @required String id,
    @required String title,
    @required String description,
    @required double price,
    @required String imageUrl,
    @required String isFavorite,
  }) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO product(id,title,description,price,imageUrl,isFavorite) VALUES("$id","$title","$description","$price","$imageUrl","$isFavorite")')
          .then((value) {
        print('Data inserted');
        emit(InsertProduct());
        getProductFromDatabase(database);
      }).catchError((onError) {
        print('Error is : $onError');
      });
      return null;
    });
  }

  void getProductFromDatabase(database) {
    database.rawQuery('SELECT * FROM product').then((value) {
      productData = value;
      print(productData);
      emit(GetProducts());
    });
  }

  void updateData({
    @required String title,
    @required String description,
    @required double price,
    @required String imageUrl,
    @required String id,
  }) async {
    await database.rawUpdate(
      'UPDATE product SET title = ? description = ? price = ? imageUrl = ? WHERE id = ?',
      [title, description, price, imageUrl, id],
    ).then((value) {
      emit(UpdateProduct());
    });
  }

  void deleteProduct(String id) {
    database.rawDelete('DELETE FROM product WHERE id = ? ', [id]).then((value) {
      getProductFromDatabase(database);
      emit(DeleteProduct());
    });
  }

// List<Map> get favorites {
//   return productData.where((element) => element.isFavorite).toList();
// }
  void toggleFavoriteStatus(
    String isFavorite,
    String id,
  ) async {
    if (isFavorite == 'true') {
      isFavorite = 'false';
    } else if (isFavorite == 'false') {
      isFavorite = 'true';
    }
    await database.rawUpdate(
      'UPDATE product SET  isFavorite = ? WHERE id = ? ',
      [isFavorite, id],
    ).then((value) {
      getProductFromDatabase(database);
      emit(UpdateProduct());
    });
    emit(UpdateProduct());
  }

  int get itemCount {
    return _items.length;
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (value) => CartItem(
                id: value.id,
                price: value.price,
                title: value.title,
                quantity: value.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
    }
    emit(InsertCart());
  }

  void removeItem(String productId) {
    _items.remove(productId);
    emit(DeleteCart());
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    emit(GetCarts());
    return total;
  }

  void clear() {
    _items = {};
    emit(DeleteCart());
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (value) => CartItem(
                id: value.id,
                title: value.title,
                quantity: value.quantity - 1,
                price: value.price,
              ));
    } else {
      _items.remove(productId);
    }
    emit(RemoveSingleCart());
  }
}

class CartItem {
  final String id;

  final String title;
  final int quantity;

  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}
