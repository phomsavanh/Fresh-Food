import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/pages/MyTabBar.dart';
import 'package:flutter_firebase/pages/detailPage.dart';
import 'package:flutter_firebase/widgets/Carousel.dart';
import 'package:flutter_firebase/widgets/Title.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List filter = List();
  List all = List();
  Random random = Random();
  void add() async {
    Firestore firestore = Firestore.instance;
    await firestore.collection('path').document('1').setData({
      'title': 'Flutter',
      'description': 'Programming Guide for Dart',
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
        print('success');
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
        print('success');
      });
    });
  }

  Future<void> checkStatus() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    if (firebaseUser == null) {
      print('not Login');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => MyTabBar()),
      );
    } else {
      print(firebaseUser);
    }
  }

  @override
  void initState() {
    this.checkStatus();
    super.initState();
    this.fetchFilter();
    this.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: MyTitle(title: 'The Best Restaurants')),
        SliverAppBar(
          centerTitle: false,
          expandedHeight: 160,
          floating: false,
          flexibleSpace: FlexibleSpaceBar(
            background: Carousel(random: random, a: filter),
          ),
        ),
        SliverToBoxAdapter(child: MyTitle(title: 'Popular Restaurants')),
        SliverGrid(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return DetailPage(name: all[index]['name']);
                      },
                    ),
                  );
                  print(all[index]['name']);
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Column(
                      children: [
                        Container(
                          color: Colors.brown.shade100,
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Image.network(
                            all[index]['image'],
                            fit: BoxFit.cover,
                            loadingBuilder:
                                (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.black26,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blueGrey),
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress
                                              .cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(all[index]['name']),
                          subtitle: Text(all[index]['type']),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }, childCount: all.length),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 0.9,
              crossAxisSpacing: 10,
              mainAxisSpacing: 25,
            )),
        SliverPadding(
          padding: EdgeInsets.all(16),
        ),
      ],
    );
  }
}
