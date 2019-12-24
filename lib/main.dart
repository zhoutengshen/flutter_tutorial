import 'package:flutter/material.dart';
import 'package:flutter_tutorial/store/StoreProvider.dart';
import 'package:flutter_tutorial/views/home/Index.dart';
import 'package:flutter_tutorial/views/add/Index.dart';

void main() => runApp(MyApp());

//简单路由配置
var _routeConfigs = {"/home": (_) => HomePage(), "/add": (_) => AddPage()};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      child: MaterialApp(
        title: "FlutterTutorial",
        routes: _routeConfigs,
        initialRoute: "/home",
      ),
    );
  }
}
