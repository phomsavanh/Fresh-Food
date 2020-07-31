import 'package:bottom_bar_page_transition/bottom_bar_page_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/pages/MyTabBar.dart';
import 'package:flutter_firebase/pages/accountPage.dart';
import 'package:flutter_firebase/pages/homePage.dart';
import 'package:flutter_firebase/pages/productsPage.dart';

class BottomNav extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<BottomNav> {
  int _selectedIndex = 0;
  List _title = ["Store", "Products", "Account"];
  List info = List();
  List filter = List();
  List all = List();

  Future<void> currentUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    Firestore db = Firestore.instance;
    await auth.currentUser().then((value) {
      db.collection('users').document(value.uid).get().then((value) {
        setState(() {
          info.add(value.data);
        });
      });
    });
  }

  void fetchFilter() async {
    Firestore firestore = Firestore.instance;
    firestore.collection('shops').limit(3).snapshots().listen((value) {
      filter = List();
      value.documents.forEach((element) {
        setState(() {
          filter.add(element.data);
        });
      });
    });
  }

  void fetchAll() async {
    Firestore firestore = Firestore.instance;
    firestore.collection('shops').snapshots().listen((value) {
      all = List();
      value.documents.forEach((element) {
        setState(() {
          all.add(element.data);
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    currentUser();
    fetchAll();
    fetchFilter();
  }

  Widget current(int ind) {
    if (ind == 0) {
      return HomePage(all, filter);
    } else if (ind == 1) {
      return ProductsPage();
    } else {
      return AccountPage(info);
    }
  }

  Widget search() {
    return IconButton(
        icon: Icon(
          Icons.exit_to_app,
          color: Colors.grey.shade500,
        ),
        onPressed: () {
          FirebaseAuth auth = FirebaseAuth.instance;
          auth.signOut().then((value) =>
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) {
                  return MyTabBar();
                },
              )));
        });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title[_selectedIndex]),
        actions: [
          search(),
        ],
      ),
      body: BottomBarPageTransition(
        builder: (context, index) => current(index),
        currentIndex: _selectedIndex,
        totalLength: 3,
        transitionType: TransitionType.fade,
        transitionDuration: Duration(milliseconds: 180),
        transitionCurve: Curves.linear,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.shifting,
        unselectedItemColor: Colors.black26,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop_two),
            title: Text('products'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('account'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
