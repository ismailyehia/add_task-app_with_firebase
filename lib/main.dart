import 'package:firebase2/api.dart';
import 'package:firebase2/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  var loggedin =
      preferences.containsKey("loggedin") ? preferences.get("loggedin") : false;
  runApp(MyApp(loggedin));
}

class MyApp extends StatelessWidget {
  

  bool? loggedin;
  MyApp(loggedin) {
    this.loggedin = loggedin;
  }

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (loggedin!) ? Authentiction() : Authentiction(),
    );
  }
}

