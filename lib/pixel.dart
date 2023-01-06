import 'dart:ui';

import 'package:da_pixel/screen/screen.dart';
import 'package:flutter/material.dart';
import 'config.dart';
import 'pixels/alphanum_s.dart';
import 'pixels_loader/base.dart';

Future<PixelLoadResult> loadAlphaNum(
    String code, double pixelSize, double pixelGap,
    {Color color = Colors.white}) async {
  var pixels = alphanum[code];

  if (pixels == null) {
    return PixelLoadResult();
  }

  var h = (pixels.length * (pixelSize + pixelGap)).toInt();
  var w = (pixels[0].length * (pixelSize + pixelGap)).toInt();

  if(Config.rotateScreen) {
    var tmp = w;
    w = h;
    h = w;
  }

  final pictureRecorder = PictureRecorder();

  var canvas =
      Canvas(pictureRecorder, Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()));

  var paint = Paint()..color = color;

  for (var i = 0; i < pixels.length; ++i) {
    var posy = i * (pixelSize + pixelGap);
    for (var j = 0; j < pixels[i].length; ++j) {
      var posx = j * (pixelSize + pixelGap);

      if (pixels[i][j] <= 0) {
        continue;
      }

      if(Config.rotateScreen) {
        canvas.drawRect(Rect.fromLTWH(pixels.length* (pixelSize + pixelGap) - posy,posx, pixelSize, pixelSize), paint);
      }
      else {
        canvas.drawRect(Rect.fromLTWH(posx, posy, pixelSize, pixelSize), paint);
      }
      
    }
  }

  var picture = pictureRecorder.endRecording();
  var image = await picture.toImage(w, h);

  var by = await image.toByteData();

  if (by == null) {
    return PixelLoadResult();
  }

  var ret = PixelData()
    ..data = by.buffer.asUint8List()
    ..width = w
    ..height = h;

  return PixelLoadResult()
    ..success = true
    ..data = ret;
}

Future<PixelLoadResult> loadBackground(Screen screen,
    {Color color = Colors.white}) async {

  final pictureRecorder = PictureRecorder();

  var canvas =
      Canvas(pictureRecorder, Rect.fromLTWH(0, 0, screen.viewPortW,screen.viewPortH));

  var paint = Paint()..color = color;

  for (var i = 0; i < screen.height; ++i) {
    var posy =  i * (screen.pixelSize + screen.pixelGap);
    for (var j = 0; j < screen.width; ++j) {
      var posx =  j * (screen.pixelSize + screen.pixelGap);

      canvas.drawRect(Rect.fromLTWH(posx, posy, screen.pixelSize, screen.pixelSize), paint);
    }
  }   

  
  var picture = pictureRecorder.endRecording();
  var image = await picture.toImage(screen.viewPortW.floor(),screen.viewPortH.floor());

  var by = await image.toByteData();

  if (by == null) {
    return PixelLoadResult();
  }

  var ret = PixelData()
    ..data = by.buffer.asUint8List()
    ..width = screen.viewPortW.floor()
    ..height = screen.viewPortH.floor();

  return PixelLoadResult()
    ..success = true
    ..data = ret;   


}

class PixelLoadResult {
  bool success = false;
  PixelData? data;
}
