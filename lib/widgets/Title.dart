
import 'package:flutter/material.dart';

class MyTitle extends StatelessWidget {
  final String title;
  const MyTitle({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 24, left: 16, bottom: 24),
      child: Text(
        title,
        style: TextStyle(color: Colors.amber[900], fontSize: 20, fontWeight: FontWeight.w800),
      ),
    );
  }
}
