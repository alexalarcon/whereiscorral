import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../redux/App.state.dart';
import '../../redux/auth/auth_actions.dart';
import '../../redux/auth/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String routeName = 'LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, AuthState>(
          distinct: false,
          converter: (store) => store.state.authState,
          builder: (context, storeData) {
            return Center(
              child: Container(
                constraints: const BoxConstraints(minWidth: 300, maxWidth: 500),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text("Iniciar sesión",
                                  style: Theme.of(context).textTheme.headline1),
                            ),
                            Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                width: double.infinity,
                                child: Text(
                                  storeData.errorMessage.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error),
                                )),
                            Container(
                              margin: const EdgeInsets.only(
                                top: 10.0,
                              ),
                              child: TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      size: 18,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 0, color: Colors.white),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 0, color: Colors.white),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  // searchData
                                  onFieldSubmitted: (text) => {}),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 15.0, bottom: 20.0),
                              child: TextFormField(
                                  controller: passController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 60),
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      size: 19,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 0, color: Colors.white),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 0, color: Colors.white),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  // searchData
                                  onFieldSubmitted: (text) => {}),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, LoginPage.routeName),
                              child: Container(
                                  margin: const EdgeInsets.only(bottom: 60.0),
                                  child: const Text(
                                      "¿Has olvidado la contraseña?")),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary:
                                        Theme.of(context).colorScheme.tertiary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    // Navigator.pop(context);
                                    // Respond to button press
                                    Redux.store.dispatch(
                                        authEmailPasswordAction(
                                            Redux.store,
                                            emailController.value.text,
                                            passController.value.text,
                                            context));
                                  },
                                  child: const Text('Aceptar'),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary:
                                        Theme.of(context).colorScheme.tertiary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    // Navigator.pop(context);
                                    // Respond to button press
                                    Redux.store
                                        .dispatch(signByGoogle(Redux.store));
                                  },
                                  child: const Text('Login with google'),
                                ),
                              ),
                            )
                          ]),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
