import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tutorial/utils/composited_font_to_image.dart';

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
  Map<String, Uint8List> _catch = {};

  double imgWidth = 4 * 64.0;
  Future<Uint8List> _assetImageToUint8List([assetStr = 'images/position.png']) async {
    if (_catch[assetStr] != null) {
      print('命中缓存');
      return Future<Uint8List>(() {
        return _catch[assetStr];
      });
    }
    Completer<Uint8List> completer = Completer();
    AssetImage(assetStr)
        .resolve(createLocalImageConfiguration(context))
        .addListener(ImageStreamListener((ImageInfo imageInfo, syc) async {
      ByteData byteData = await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List buffList = byteData.buffer.asUint8List();
      completer.complete(Future<Uint8List>((){
        return buffList;
      }));
      _catch[assetStr] = buffList;
    }));
    return completer.future;
  }
  Future<ui.Image> uint8ListToUiImage(Uint8List data){
    Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(data, (ui.Image image){
      completer.complete(Future<ui.Image>(()=>image));
    });
    return completer.future;
  }

  Future<Uint8List> compositeFontToImage() async{
    Uint8List data = await _assetImageToUint8List();
    ui.PictureRecorder recorder = new ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    ui.Image image =await uint8ListToUiImage(data);
    final paint = Paint();
    canvas.drawImage(image, Offset(0,0), paint);
    // 在canvas上面绘制文字
    ui.ParagraphBuilder pb = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontWeight: FontWeight.w500,
      fontSize: imgWidth/5,
    ));
    pb.pushStyle(ui.TextStyle(
        color: Colors.red,
        fontSize: imgWidth/5
    ));
    pb.addText("周先生");
    ui.ParagraphConstraints pc = ui.ParagraphConstraints(width: imgWidth);

    ui.Paragraph paragraph = pb.build()..layout(pc);
    // 将文字画上去
    canvas.drawParagraph(paragraph, Offset(0,imgWidth/3));
    // 将 ui.image 图片转化为 Uint8List
    ui.Image canvasImage =await recorder.endRecording().toImage(imgWidth.toInt(), imgWidth.toInt()+20);
    ByteData canvasByteData =await canvasImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List canvasUint8List = Uint8List.view(canvasByteData.buffer);
    return canvasUint8List;
  }

  CompositedFontToImage cfti = new CompositedFontToImage();

  List<Widget> widgets = [];
  click() async{
    // 这里利用cavans 进行合成
    // 画图

    Uint8List canvasUint8List = await cfti.compositeFontToImage(context, ui.TextStyle(
        color: Colors.red,
        fontSize: imgWidth/5
    ), 4 * 64 + 20, 4 * 64,  Offset(0,4 * 64/3), '周騰深', 'images/position.png');

    // 将 Uint8List 转化为 Widget/Image
    var widget = Image.memory(canvasUint8List,width: 40,height: 40,);
    if(widgets.length==0){
      widgets.add(widget);
    }else{
      widgets[0] = widget;
    }
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('Widget To Image demo'),
        ),
        body: Row(
          children: <Widget>[
            Center(
              child: RaisedButton(
                child: Text('ok'),
                onPressed: click,
              ),
            ),
          ]..addAll(widgets),
        ),
      ),
    );
  }
}
