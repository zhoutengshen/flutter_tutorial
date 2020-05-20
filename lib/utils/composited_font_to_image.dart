import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';

class CompositedFontToImage {
  Map<String, Uint8List> _catch = {};
  Future<Uint8List> _assetImageToUint8List(context,
      [assetStr = 'images/position.png']) async {
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
      ByteData byteData =
          await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List buffList = byteData.buffer.asUint8List();
      completer.complete(Future<Uint8List>(() {
        return buffList;
      }));
      _catch[assetStr] = buffList;
    }));
    return completer.future;
  }

  Future<ui.Image> _uint8ListToUiImage(Uint8List data) {
    Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(data, (ui.Image image) {
      completer.complete(Future<ui.Image>(() => image));
    });
    return completer.future;
  }

  Future<Uint8List> compositeFontToImage(
    context,
    ui.TextStyle textStyle,
    int height,
    int width,
    Offset fontOffset,
    String text,
    String assetImgUrl,
  ) async {
    Uint8List data = await _assetImageToUint8List(context,assetImgUrl);
    ui.PictureRecorder recorder = new ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    ui.Image image = await _uint8ListToUiImage(data);
    final paint = Paint();
    canvas.drawImage(image, Offset(0, 0), paint);
    // 在canvas上面绘制文字
    ui.ParagraphBuilder pb = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontWeight: FontWeight.w500,
    ));
    pb.pushStyle(textStyle);
    pb.addText(text);
    ui.ParagraphConstraints pc =
        ui.ParagraphConstraints(width: width.toDouble());
    ui.Paragraph paragraph = pb.build()..layout(pc);
    // 将文字画上去
    canvas.drawParagraph(paragraph, fontOffset);
    // 将 ui.image 图片转化为 Uint8List
    ui.Image canvasImage = await recorder.endRecording().toImage(width, height);
    ByteData canvasByteData =
        await canvasImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List canvasUint8List = Uint8List.view(canvasByteData.buffer);
    return canvasUint8List;
  }
}
