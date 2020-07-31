import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_firebase/pages/MyTabBar.dart';
import 'package:flutter_firebase/pages/detailPage.dart';
import 'package:flutter_firebase/widgets/Carousel.dart';
import 'package:flutter_firebase/widgets/Title.dart';

class HomePage extends StatefulWidget {
  final List all;
  final List filter;
  HomePage(this.all, this.filter);
  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

  Random random = Random();


  Future<void> checkStatus() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    if (firebaseUser == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => MyTabBar()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    this.checkStatus();
  }

  @override
  Widget build(BuildContext context) {
    return widget.all.isEmpty
        ? CircularProgressIndicator()
        : CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: MyTitle(title: 'The Best Restaurants')),
              SliverAppBar(
                centerTitle: false,
                expandedHeight: 160,
                floating: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Carousel(random: random, a: widget.filter),
                ),
              ),
              SliverToBoxAdapter(child: MyTitle(title: 'Popular Restaurants')),
              SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return DetailPage(name: widget.all[index]['name']);
                            },
                          ),
                        );
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
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Image.network(
                                  widget.all[index]['image'],
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.black26,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.blueGrey),
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              ListTile(
                                title: Text(widget.all[index]['name']),
                                subtitle: Text(widget.all[index]['type']),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }, childCount: widget.all.length),
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
