import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  final List info;

  AccountPage(this.info);
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return widget.info.isEmpty
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
                        'Your infomation',
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
                      "Name: ${widget.info[0]['name']}",
                      style:
                          TextStyle(fontSize: 24, color: Colors.amber.shade800),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16, bottom: 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Email: ${widget.info[0]['email']}",
                      style:
                          TextStyle(fontSize: 24, color: Colors.amber.shade800),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16, bottom: 8),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Phone: ${widget.info[0]['phone']}",
                      style:
                          TextStyle(fontSize: 24, color: Colors.amber.shade800),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
