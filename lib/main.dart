import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'pages/login/login.dart';

import 'redux/App.state.dart';
import 'redux/auth/auth_actions.dart';
import 'redux/auth/auth_state.dart';

// https://firebase.flutter.dev/docs/firestore/usage/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Redux.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Redux.store.dispatch(currentUser);
  runApp(const MyApp());
}

final db = FirebaseFirestore.instance;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: Redux.store,
        child: StoreConnector<AppState, AuthState>(
            distinct: true,
            converter: (store) => store.state.authState,
            builder: (context, authState) {
              return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Lecturas',
                  theme: themeApp(),
                  initialRoute: (authState.user != null)
                      ? LoginPage.routeName
                      : LoginPage.routeName,
                  routes: routes);
            }));
  }

  Map<String, WidgetBuilder> get routes {
    return {
      LoginPage.routeName: (BuildContext context) => const LoginPage(),
    };
  }

  ThemeData themeApp() {
    return ThemeData(
        fontFamily: 'Poppins',
        splashColor: Colors.white,
        highlightColor: const Color(0xFFF3F6FC).withOpacity(.3),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF212240),
          secondary: const Color(0xFF62628A),
          tertiary: const Color(0xFF3F72AF),
          background: const Color(0xFFF3F6FC),
          error: const Color(0xFFFF4D4D),
        ),
        textTheme: const TextTheme(
          bodyText1: TextStyle(fontSize: 14.0, color: Colors.black87),
          bodyText2: TextStyle(fontSize: 14.0, color: Color(0xFF62628A)),
          headline1: TextStyle(
            color: Color(0xFF212240),
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
          headline2: TextStyle(
              fontSize: 16.0, color: Color(0xFF212240), fontFamily: 'Poppins'),
          headline3: TextStyle(
              fontSize: 14.0, color: Color(0xFF62628A), fontFamily: 'Poppins'),
          headline4: TextStyle(
              color: Color(0xFF3F72AF),
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins'),
          subtitle1: TextStyle(
            color: Color(0xFF212240),
            fontSize: 16.0,
          ),
          subtitle2: TextStyle(
              color: Color(0xFF212240),
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins'),
          caption: TextStyle(
              fontFamily: 'Poppins', color: Color(0xFF212240), fontSize: 12),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: Colors.black, size: 20),
          titleTextStyle: TextStyle(
              color: Colors.black, fontSize: 16, fontFamily: 'Poppins'),
          // This removes the shadow from all App Bars.
        ),

        // textTheme: TextTheme(he),
        tabBarTheme: const TabBarTheme(
            labelColor: Color(0xFF3F72AF),
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF3F72AF)),
              ),
            )),
        //https://api.flutter.dev/flutter/material/TextTheme-class.html
        // textTheme: TextTheme(te),
        scaffoldBackgroundColor: const Color(0xFFF3F6FC),
        disabledColor: const Color(0xFF8C8C8C),
        primaryIconTheme:
            const IconThemeData(color: Color.fromARGB(255, 26, 216, 216)));
  }
}
