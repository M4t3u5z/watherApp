import 'package:flutter/material.dart';

import 'SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, // Usuwa wstążkę "DEBUG"
        title: Strings.appTitle,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen());
  }
}

class Strings {
  static const String appTitle = 'Clean Air';
}
