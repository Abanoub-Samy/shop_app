import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class SqlDataBase {
  Database database;

  void createDatabase() async {
    database = await openDatabase('ShopApp', version: 30,
        onCreate: (Database db, int version) {
      print('Database created');
      db
          .execute(
              'CREATE TABLE product (id TEXT PRIMARY KEY, title TEXT,description TEXT, price Double, imageUrl TEXT,isFavorite Boolean)')
          .then((value) {
        print('table product created');
      }).catchError((onError) {
        print('Error is : $onError');
      });
    });
  }

  void insertProduct({
    @required String id,
    @required String title,
    @required String description,
    @required double price,
    @required String imageUrl,
    bool isFavorite = false,
  }) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO product(id,title,description,price,imageUrl,isFavorite) VALUES("$id","$title","$description","$price","$imageUrl","$isFavorite")')
          .then((value) {
        print('Data inserted');
      }).catchError((onError) {
        print('Error is : $onError');
      });
      return null;
    });
  }

  Future<List> getProductFromDatabase() async {
    return await database.rawQuery('SELECT * FROM product');
  }
}
