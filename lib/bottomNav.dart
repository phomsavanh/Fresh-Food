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
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget current(int ind) {
    if (ind == 0) {
      return HomePage();
    } else if (ind == 1) {
      return ProductsPage();
    } else {
      return AccountPage();
    }
  }

  Widget search() {
    return IconButton(
        icon: Icon(
          Icons.search,
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
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOutCirc,);
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
      body: PageView(
        physics: BouncingScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
        children: <Widget>[
          HomePage(),
          ProductsPage(),
          AccountPage(),
        ],
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
