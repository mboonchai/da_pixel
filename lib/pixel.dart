import 'dart:ui';

import 'package:da_pixel/pixels/alphanum_l.dart';
import 'package:da_pixel/screen/screen.dart';
import 'package:flutter/material.dart';
import 'config.dart';
import 'pixels/alphanum_s.dart';
import 'pixels_loader/base.dart';

enum CharSize {
  small,
  large,
}

Future<PixelLoadResult> loadAlphaNum(Screen screen,
    String code, {Color color = Colors.white,CharSize size =CharSize.small }) async {
  var pixels = size==CharSize.small?alphanum[code]:alphanumLarge[code];

  if (pixels == null) {
    return PixelLoadResult();
  }

  var pxSize = screen.getSpritePixelSize();
  var pxGap = screen.getSpritePixelGap();


  var h = (pixels.length * (pxSize+pxGap)).toInt();
  var w = (pixels[0].length * (pxSize+pxGap)).toInt();

  // if(Config.rotateScreen) {
  //   var tmp = w;
  //   w = h;
  //   h = tmp;
  // }

  final pictureRecorder = PictureRecorder();

  var canvas =
      Canvas(pictureRecorder, Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()));

  var paint = Paint()..color = color;

  for (var i = 0; i < pixels.length; ++i) {
    var posy = i * (pxSize+pxGap);
    for (var j = 0; j < pixels[i].length; ++j) {
      var posx = j * (pxSize+pxGap);

      if (pixels[i][j] <= 0) {
        continue;
      }

      // if(Config.rotateScreen) {
      //   canvas.drawRect(Rect.fromLTWH((pixels.length-1)* (pxSize+pxGap) - posy,posx, pxSize, pxSize), paint);
      // }
      // else {
        canvas.drawRect(Rect.fromLTWH(posx, posy, pxSize, pxSize), paint);
      //}
      
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

//ALWAYS LOADED WITH LANDSCAPE SIDE
Future<PixelLoadResult> loadBackground(Screen screen,
    {Color color = Colors.white}) async {

  var h = Config.rotateScreen? screen.viewPortW : screen.viewPortH;
  var w = Config.rotateScreen? screen.viewPortH : screen.viewPortW;

  var pxh = Config.rotateScreen? screen.width : screen.height;
  var pxw = Config.rotateScreen? screen.height : screen.width;

  final pictureRecorder = PictureRecorder();

  var canvas =
      Canvas(pictureRecorder, Rect.fromLTWH(0, 0, w,h));

  var paint = Paint()..color = color;

  var pxSize = screen.getSpritePixelSize();
  var pxGap = screen.getSpritePixelGap();



  for (var i = 0; i < pxh; ++i) {
    var posy =  i * (pxSize+pxGap);
    for (var j = 0; j < pxw; ++j) {
      var posx =  j * (pxSize+pxGap);

      canvas.drawRect(Rect.fromLTWH(posx, posy, pxSize,pxSize), paint);
    }
  }   


  
  var picture = pictureRecorder.endRecording();
  var image = await picture.toImage(w.floor(),h.floor());

  var by = await image.toByteData();

  if (by == null) {
    return PixelLoadResult();
  }

  var ret = PixelData()
    ..data = by.buffer.asUint8List()
    ..width = w.floor()
    ..height = h.floor();


  return PixelLoadResult()
    ..success = true
    ..data = ret;   


}

class PixelLoadResult {
  bool success = false;
  PixelData? data;
}
