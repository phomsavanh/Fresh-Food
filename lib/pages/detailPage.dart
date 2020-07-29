import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final String name;
  DetailPage({this.name});
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List all = List();
  String image = "";
  int select = 0;
  void fetchAll() async {
    Firestore firestore = Firestore.instance;
    firestore
        .collection('products')
        .where('shop', isEqualTo: widget.name)
        .snapshots()
        .listen((value) {
      all = List();
      value.documents.forEach((element) {
        setState(() {
          all.add(element.data);
        });
        print(all);
      });
    });
  }

  @override
  void initState() {
    fetchAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: all.isEmpty? Center(child: CircularProgressIndicator(),): CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            floating: true,
            pinned: true,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.amber.shade700,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              title: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Text(
                  '${widget.name}',
                  style: TextStyle(color: Colors.amber.shade800),
                ),
              ),
              centerTitle: true,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  image == ""
                      ? Image.network(
                          all[0]['image'],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            print("loading: $loadingProgress");
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.black26,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blueGrey),
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                        )
                      : Image.network(
                          image,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.green,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blueGrey),
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                        ),
                  Container(
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    onTap: () {
                      setState(() {
                        image = all[index]['image'];
                        select = index;
                      });
                    },
                    hoverColor: Colors.green,
                    selected: select == index ? true : false,
                    title: Text(
                      all[index]['product'],
                      style: TextStyle(
                          color: Colors.amber.shade500,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(all[index]['type']),
                    trailing: Text("${all[index]['price']} kip"),
                  ),
                  //your main widget is here
                  Divider(height: 0.01),
                ],
              );
            }, childCount: all.length),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(all[select]);
        },
        backgroundColor: Colors.amber,
        child: Icon(Icons.add_shopping_cart),
      ),
    );
  }
}
