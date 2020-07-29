import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'detailPage.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List a = List();
  List b = List();
  List c = List();

  Future<void> fetchAll() async {
    Firestore firestore = Firestore.instance;
    firestore.collection('shops').snapshots().listen((value) {
      a = List();
      value.documents.forEach((element) {
        setState(() {
          a.add(element.data);
        });
        c = List.from(a);

        print('success');
      });
    });
  }

  void filter({String name}) {
    setState(() {
      a = c.where((element) => element['type'] == "$name").toList();
      print('a: $a');
      print(c);
    });
  }

  Future<void> myType() async {
    Firestore firestore = Firestore.instance;
    firestore.collection('shops').snapshots().listen((value) {
      b = List();
      value.documents.forEach((element) {
        setState(() {
          b.add(element.data['type']);
          b = b.toSet().toList();
        });

        print('success');
      });
    });
  }

  void getAll() async {
    await fetchAll();
    await myType();
  }

  @override
  void initState() {
    getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              MyFilter(
                func: () => fetchAll(),
                name: "All",
              ),
              ...List.generate(b.length, (index) {
                return MyFilter(
                    name: b[index],
                    func: () {
                      filter(
                        name: b[index],
                      );
                    });
              })
            ],
          ),
        ),
        Expanded(
          flex: 9,
          child: GridView.count(
              padding: EdgeInsets.all(8),
              mainAxisSpacing: 16,
              crossAxisSpacing: 4,
              crossAxisCount: 2,
              children: List.generate(
                a.length,
                (index) => Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: InkWell(
                    onTap: () {
                      myType();
                      print(b);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return DetailPage(name: a[index]['name']);
                          },
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: Column(
                        children: [
                          Container(
                            color: Colors.brown.shade100,
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Image.network(
                              a[index]['image'],
                              fit: BoxFit.cover,
                            ),
                          ),
                          ListTile(
                            title: Text(a[index]['name']),
                            subtitle: Text(a[index]['type']),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        )
      ],
    );
  }
}

class MyFilter extends StatelessWidget {
  final func;

  final String name;
  const MyFilter({Key key, this.func, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: OutlineButton(
        highlightColor: Colors.amber.shade100,
        highlightedBorderColor: Colors.amber.shade200,
        hoverColor: Colors.amberAccent,
        borderSide: BorderSide(
          color: Colors.amber.shade500,
          width: 2,
          style: BorderStyle.solid,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        onPressed: () {
          this.func();
        },
        child: Text(
          this.name,
          style: TextStyle(color: Colors.amber.shade600),
        ),
      ),
    );
  }
}
