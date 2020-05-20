import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey _globalKey = new GlobalKey();
  List<Uint8List> imageDatas = [];
  Future<Uint8List> _capturePng() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      if (boundary.debugNeedsPaint) {
        print("Waiting for boundary to be painted.");
        //延时 20 毫秒后，boundary.debugNeedsPaint 会变为 false,再执行 _capturePng 函数。
        await Future.delayed(const Duration(milliseconds: 20));
        return _capturePng();
      }
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
//      print(bs64);
      imageDatas.add(pngBytes);
      setState(() {});
      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('Widget To Image demo'),
        ),
        body: Stack(
          children: <Widget>[
            new Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    'click below given button to capture iamge',
                  ),
                  new RaisedButton(
                    child: Text('capture Image'),
                    onPressed: _capturePng,
                  ),
                  Container(
                    height: 500,
                    child: ListView.builder(
                      itemCount: imageDatas.length,
                      itemBuilder: (ctx, index) => Image.memory(
                        imageDatas[index],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              left: 30,
              child: RepaintBoundary(
                key: _globalKey,
                child: Text(
                  'okkk',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
