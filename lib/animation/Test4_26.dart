import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Entry.dart';

// 卸载程序会消失

void main() => runApp(MyEntry(
      widget: SharedPreferencesTestWidget(),
    ));

class SharedPreferencesTestWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SharedPreferencesTestState();
  }
}

class SharedPreferencesTestState extends State<SharedPreferencesTestWidget> {
  SharedPreferences dbInstance;

  initState() {
    super.initState();
    init();
  }

  init() async{
    dbInstance = await SharedPreferences.getInstance();
  }

  String value;

  getValueFromLocal(String key) async {
    String value;
    try {
       value = dbInstance.get(key);
    } catch (e) {
      print(e);
      value = "ERROR";
    }
    setState(() {
      this.value = value;
    });
  }

  saveValueToLocal(String key, String value) async {
    try {
      DateTime time = DateTime.now();
      dbInstance.setString(key, value + ":" + time.second.toString());
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        children: <Widget>[
          Container(
            height: 100,
          ),
          RaisedButton(
            onPressed: () {
              saveValueToLocal("TEST1", "SAVE TEST1");
            },
            child: Text("SAVE TEST1"),
          ),
          RaisedButton(
            onPressed: () {
              saveValueToLocal("TEST2", "SAVE TEST2");
            },
            child: Text("SAVE TEST2"),
          ),
          RaisedButton(
            onPressed: () {
              getValueFromLocal("TEST1");
            },
            child: Text("GET TEST1"),
          ),
          RaisedButton(
            onPressed: () {
              getValueFromLocal("TEST2");
            },
            child: Text("GET TEST2"),
          ),
          Text(value??""),
        ],
      ),
    );
  }
}
