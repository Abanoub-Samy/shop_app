import 'package:flutter/material.dart';
import 'package:shop_app/dataBase/AppCubit.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();

  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  List<Map> productData = [];

  // var _isInit = true;
  // var _initValues = {
  //   'title': '',
  //   'description': '',
  //   'price': '',
  //   'imageUrl': '',
  // };
  // var _values = {
  //   'title': '',
  //   'description': '',
  //   'price': 0,
  //   'imageUrl': '',
  // };

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

  void _saveForm() {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    AppCubit.get(context).insertProduct(
      id: DateTime.now().toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      price: double.parse(_priceController.text),
      imageUrl: _imageUrlController.text,
      isFavorite: 'false',
    );
    _form.currentState.save();

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   reloadData();
  //   super.didChangeDependencies();
  // }

  // void reloadData(BuildContext context) {
  //   if (_isInit) {
  //     final productId = ModalRoute.of(context).settings.arguments as String;
  //     print(productId);
  //     if (productId != null) {
  //       AppCubit.get(context).getProductById(productId).then((value) {
  //         productData = value;
  //       });
  //       print(productData);
  //       // _initValues = {
  //       //   'title': productData[0]['title'],
  //       //   'description': productData[0]['description'],
  //       //   'price': productData[0]['price'].toString(),
  //       //   'imageUrl': '',
  //       // };
  //       // _imageUrlController.text = productData[0]['imageUrl'];
  //     }
  //   }
  //   _isInit = false;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm();
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
                // initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                controller: _titleController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter Title.';
                  }
                  return null;
                },
              ),
              TextFormField(
                // initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                controller: _priceController,
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
                // initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                controller: _descriptionController,
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
