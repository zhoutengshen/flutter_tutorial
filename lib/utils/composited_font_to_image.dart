import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';

class CompositedFontToImage {
  static Map<String, Future<Uint8List>> _catch = {};
  static Map<String, Future<ui.Image>> _catchUiImage = {};
  BuildContext context;
  String assetImgUrl;

  CompositedFontToImage(context, assetImgUrl) {
    _assetImageToUint8List(context, assetImgUrl);
    _assetImageToUiImage(context, assetImgUrl);
    this.context = context;
    this.assetImgUrl = assetImgUrl;
  }

  Future<Uint8List> _assetImageToUint8List(context,
      [assetStr = 'images/position.png']) async {
    if (_catch[assetStr] != null) {
      print('命中缓存');
      return _catch[assetStr];
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
    }));
    _catch[assetStr] = completer.future;
    return _catch[assetStr];
  }

  Future<ui.Image> _assetImageToUiImage(context,
      [assetStr = 'images/position.png']) async {
    if (_catchUiImage[assetStr] != null) {
      print('命中缓存');
      return _catchUiImage[assetStr];
    }
    Completer<ui.Image> completer = Completer();
    AssetImage(assetStr)
        .resolve(createLocalImageConfiguration(context))
        .addListener(ImageStreamListener((ImageInfo imageInfo, syc) async {
      completer.complete(Future<ui.Image>(() {
        return imageInfo.image;
      }));
    }));
    _catchUiImage[assetStr] = completer.future;
    return _catchUiImage[assetStr];
  }

  Future<ui.Image> _uint8ListToUiImage(Uint8List data) {
    Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(data, (ui.Image image) {
      completer.complete(Future<ui.Image>(() => image));
    });
    return completer.future;
  }

  Future<Uint8List> compositeFontToImage(
    ui.TextStyle textStyle,
    int height,
    int width,
    Offset fontOffset,
    String text,
  ) async {
    ui.Image image = await _catchUiImage[assetImgUrl];
    ui.PictureRecorder recorder = new ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    final paint = Paint();
    canvas.drawImage(image, Offset(0, 0), paint);
//    // 在canvas上面绘制文字
    ui.ParagraphBuilder pb = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontWeight: FontWeight.w500,
    ));
    pb.pushStyle(textStyle);
    pb.addText(text);
    ui.ParagraphConstraints pc =
        ui.ParagraphConstraints(width: width.toDouble());
    ui.Paragraph paragraph = pb.build()..layout(pc);
//    // 将文字画上去
    canvas.drawParagraph(paragraph, fontOffset);
//    // 将 ui.image 图片转化为 Uint8List
    ui.Image canvasImage = await recorder.endRecording().toImage(width, height);
    ByteData canvasByteData =
        await canvasImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List canvasUint8List = Uint8List.view(canvasByteData.buffer);
    return canvasUint8List;
  }
}
