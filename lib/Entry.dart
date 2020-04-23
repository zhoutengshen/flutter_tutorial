import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyEntry extends StatelessWidget {
  final Widget widget;

  const MyEntry({Key key, this.widget}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body:widget,
      ),
    );
  }
}

