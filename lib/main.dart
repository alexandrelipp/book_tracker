import 'package:provider/provider.dart';
import 'providers/firebaseProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:simple_book_tracker/assets/constants.dart';

import './screens/loginScreen.dart';
import './screens/mainScreen.dart';
import './screens/addBookScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<FirebaseProvider>(create: (context) => FirebaseProvider()),
        //ChangeNotifierProvider<Book>(create: (context) => Book()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final _initializaton = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: primaryColor,
        accentColor: primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final user = snapshot.data;
          print('user :$user');
          if (user == null) {
            print('user is logged out');
            return LoginScreen();
          } else {
            print('user is logged in');
            return MainScreen();
          }
        },
      ),
      routes: {
        AddBookScreen.routeName: (context) => AddBookScreen(),
      },
    );
  }
}
