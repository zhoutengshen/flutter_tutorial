import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../Entry.dart';

void main() => runApp(MyEntry(
      widget: App(),
    ));

class FileManager {
  static Future<File> getFile(String path) async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String documentsPath = documentsDir.path;
    File file = new File('$documentsPath/$path');
    return file;
  }

  static Future<List<String>> readAsLines({String path = 'tracker.tk'}) async {
    File file = await getFile(path);
    if (!file.existsSync()) {
      return [];
    } else {
      return file.readAsLines();
    }
  }

  static Future<File> appendDataWidthLineBreak(String data,
      {String path = 'tracker.tk'}) async {
    File file = await getFile(path);
    if (!file.existsSync()) {
      file.createSync();
    }
    return file.writeAsString('$data\n', mode: FileMode.append);
  }

  static removeFile({String path = 'tracker.tk'}) async {
    File file = await getFile(path);
    if (file.existsSync()) {
      try {
        file.deleteSync();
        return true;
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  static Future<String> readFile({String path = 'tracker.tk'}) async {
    File file = await getFile(path);
    if(file.existsSync()){
      return file.readAsStringSync();
    }else{
      return "";
    }
  }
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AppState();
  }
}

class AppState extends State<App> {
  String value = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            child: Text("Write"),
            onPressed: () {
              String str = DateTime.now().toString();
              FileManager.appendDataWidthLineBreak(str);
            },
          ),
          RaisedButton(
            child: Text("Read"),
            onPressed: () {
//              FileManager.readAsLines().then((lines) {
//                if (lines != null) {
//                  setState(() {
//                    value = lines.join("");
//                  });
//                }
//              });

              FileManager.readFile().then((value) {
                setState(() {
                  this.value = value;
                });
              });
            },
          ),
          RaisedButton(
            child: Text("Delete"),
            onPressed: () {
              FileManager.removeFile();
            },
          ),
          Text(value),
        ],
      ),
    );
  }
}
