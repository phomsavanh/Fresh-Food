import 'package:flutter/material.dart';
import 'package:flutter_firebase/pages/RegisterPage.dart';

import 'LoginPage.dart';

class MyTabBar extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<MyTabBar> {
  TextEditingController a = TextEditingController();

  List<Widget> container = [
    LoginPage(),
    RegisterPage()
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text("Get Start"),
          bottom: TabBar(
            
            tabs: [
              Tab(
                text: 'Login',
              ),
              Tab(
                text: 'Register',
              )
            ],
          ),
        ),
        body: TabBarView(children: container),
      ),
    );
  }
}
