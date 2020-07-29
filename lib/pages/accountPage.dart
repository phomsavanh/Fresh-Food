import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List info = List();
  String users;

  Future<void> currentUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    Firestore db = Firestore.instance;
    await auth.currentUser().then(
          (value) =>
              db.collection('users').document(value.uid).get().then((value) {
            setState(() {
              info.add(value.data);
            });

            print(info);
          }),
        );
  }

  @override
  void initState() {
    super.initState();
    currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return info.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Card(
          margin: EdgeInsets.all(16),
          elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Center(
                      child: Text(
                        'Your Infomation',
                        style: TextStyle(fontSize: 32, color: Colors.grey),
                      ),
                    ),
                  ),
                  Divider(
                    indent: 8,
                    endIndent: 8,
                    color: Colors.amber,
                    thickness: 3,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16, bottom: 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Name: ${info[0]['name']}",
                      style:
                          TextStyle(fontSize: 24, color: Colors.amber.shade800),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16, bottom: 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Email: ${info[0]['email']}",
                      style:
                          TextStyle(fontSize: 24, color: Colors.amber.shade800),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16, bottom: 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Phone: ${info[0]['phone']}",
                      style:
                          TextStyle(fontSize: 24, color: Colors.amber.shade900),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
