import 'package:flutter/material.dart';
import 'package:flutter_firebase/bottomNav.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 0,
          centerTitle: true,
          textTheme: TextTheme(
            // ignore: deprecated_member_use
            title: TextStyle(color: Colors.grey.shade700, fontSize: 20),
          ),
        ),
      ),
      home: BottomNav(),
    );
  }
}
