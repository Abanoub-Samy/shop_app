import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/dataBase/AppCubit.dart';
import 'package:shop_app/dataBase/appStates.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/signUp_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  bool isVisible = true;
  var emailText = TextEditingController();
  var passwordText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Login Page',
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'Login',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'E-mail',
                                prefixIcon: const Icon(Icons.mail),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              controller: emailText,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please enter an e-mail';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: isVisible,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: isVisible
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      isVisible = !isVisible;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              controller: passwordText,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'please enter password';
                                } else if (value.length < 8) {
                                  return 'password must be 8 characters at least';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  AppCubit.get(context).insertProduct(
                                    id: 'p1',
                                    title: 'Red Shirt',
                                    description:
                                        'A red shirt - it is pretty red!',
                                    price: 29.99,
                                    imageUrl:
                                        'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
                                    isFavorite: 'true',
                                  );
                                  AppCubit.get(context).insertProduct(
                                    id: 'p2',
                                    title: 'Trousers',
                                    description: 'A nice pair of trousers.',
                                    price: 59.99,
                                    imageUrl:
                                        'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
                                    isFavorite: 'false',
                                  );
                                  AppCubit.get(context).insertProduct(
                                    id: 'p3',
                                    title: 'Yellow Scarf',
                                    description:
                                        'Warm and cozy - exactly what you need for the winter.',
                                    price: 19.99,
                                    imageUrl:
                                        'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
                                    isFavorite: 'true',
                                  );
                                  AppCubit.get(context).insertProduct(
                                    id: 'p4',
                                    title: 'A Pan',
                                    description: 'Prepare any meal you want.',
                                    price: 49.99,
                                    imageUrl:
                                        'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
                                    isFavorite: 'false',
                                  );
                                  if (formKey.currentState.validate()) {
                                    Navigator.of(context).pushReplacementNamed(
                                        ProductsOverviewScreen.routeName);
                                  }
                                },
                                child: Text('login'),
                                style: ButtonStyle(),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Don\'t have an account ?',
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed(SignUpScreen.routeName);
                                  },
                                  child: const Text(
                                    'Register Now',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
