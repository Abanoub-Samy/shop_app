import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/dataBase/sqlDatabase.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();

  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm(var sqlDatabase) {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    if (_editProduct.id != null) {
      Provider.of<Products>(
        context,
        listen: false,
      ).updateProduct(_editProduct.id, _editProduct);
    } else {
      sqlDatabase.insertProduct(
        id: _editProduct.id,
        title: _editProduct.title,
        description: _editProduct.description,
        price: _editProduct.price,
        imageUrl: _editProduct.imageUrl,
      );
      Provider.of<Products>(
        context,
        listen: false,
      ).addProduct(_editProduct);
    }

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editProduct = Provider.of<Products>(
          context,
          listen: false,
        ).findById(productId);
        _initValues = {
          'title': _editProduct.title,
          'description': _editProduct.description,
          'price': _editProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final sqlDatabase = Provider.of<SqlDataBase>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm(sqlDatabase);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _editProduct = Product(
                      title: value,
                      price: _editProduct.price,
                      id: _editProduct.id,
                      imageUrl: _editProduct.imageUrl,
                      description: _editProduct.description,
                      isFavorite: _editProduct.isFavorite);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter Title.';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _editProduct = Product(
                    title: _editProduct.title,
                    price: double.parse(value),
                    id: _editProduct.id,
                    imageUrl: _editProduct.imageUrl,
                    description: _editProduct.description,
                    isFavorite: _editProduct.isFavorite,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter Price.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please Enter Valid Number.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please Enter Number Getter Than Zero.';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  _editProduct = Product(
                    title: _editProduct.title,
                    price: _editProduct.price,
                    id: _editProduct.id,
                    imageUrl: _editProduct.imageUrl,
                    description: value,
                    isFavorite: _editProduct.isFavorite,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter Description.';
                  }
                  if (value.length < 10) {
                    return 'Should Be At Least 10 Character long.';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 4,
                  right: 4,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        child: _imageUrlController.text.isEmpty
                            ? Text('Enter The Url')
                            : FittedBox(
                                child: Image.network(_imageUrlController.text),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (_) {
                          _saveForm(sqlDatabase);
                        },
                        onSaved: (value) {
                          _editProduct = Product(
                              title: _editProduct.title,
                              price: _editProduct.price,
                              id: _editProduct.id,
                              imageUrl: value,
                              description: _editProduct.description,
                              isFavorite: _editProduct.isFavorite);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Enter An Image URL.';
                          }
                          if (!value.startsWith('http') &&
                              !value.startsWith('https')) {
                            return 'Please Enter A Valid URL.';
                          }
                          if (!value.endsWith('.png') &&
                              !value.endsWith('.jpg') &&
                              !value.endsWith('.jpeg')) {
                            return 'Please Enter A Valid Image URL.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
