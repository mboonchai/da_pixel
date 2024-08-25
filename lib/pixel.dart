import 'dart:math';
import 'dart:ui';

import 'package:da_pixel/pixels/alphanum_l.dart';
import 'package:da_pixel/screen/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pixels/alphanum_s.dart';
import 'pixels_loader/base.dart';
import 'package:image/image.dart' as img;

enum CharSize {
  small,
  large,
}

Future<PixelLoadResult> loadWords(Screen screen, String word,
    {Color color = Colors.white, CharSize size = CharSize.small}) async {
  var chars = word.characters.toList();

  var charPixels = <List<List<int>>>[];

  for (var c in chars) {
    var pixels = size == CharSize.small ? alphanum[c] : alphanumLarge[c];

    if (pixels == null) {
      //some characters is missing -> failed!
      return PixelLoadResult();
    }
    charPixels.add(pixels);
  }

  if (charPixels.isEmpty) {
    return PixelLoadResult();
  }

  var pxSize = screen.getSpritePixelSize();
  var pxGap = screen.getSpritePixelGap();

  var h = 0;
  var w = 0;

  for (var px in charPixels) {
    h = max(h, (px.length * (pxSize + pxGap)).toInt());
    w += (px[0].length* (pxSize + pxGap)).toInt();
  }

    final pictureRecorder = PictureRecorder();

  var canvas =
      Canvas(pictureRecorder, Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()));
  
  var paint = Paint()..color = color;


  var curlenx = 0;
  for(var cx=0;cx<charPixels.length;++cx) {

    var c = charPixels[cx];

    for (var i = 0; i < c.length; ++i) {
      var posy = i * (pxSize + pxGap);
      for (var j = 0; j < c[i].length; ++j) {
        var posx = (j+curlenx) * (pxSize + pxGap);

        if (c[i][j] <= 0) {
          continue;
        }

        canvas.drawRect(Rect.fromLTWH(posx.toDouble(), posy.toDouble(), pxSize.toDouble(), pxSize.toDouble()), paint);
      }
    }

    curlenx += c[0].length;
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

Future<PixelLoadResult> loadAlphaNum(Screen screen, String code,
    {Color color = Colors.white, CharSize size = CharSize.small}) async {
  var pixels = size == CharSize.small ? alphanum[code] : alphanumLarge[code];

  if (pixels == null) {
    return PixelLoadResult();
  }

  var pxSize = screen.getSpritePixelSize();
  var pxGap = screen.getSpritePixelGap();

  var h = (pixels.length * (pxSize + pxGap)).toInt();
  var w = (pixels[0].length * (pxSize + pxGap)).toInt();

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
    var posy = i * (pxSize + pxGap);
    for (var j = 0; j < pixels[i].length; ++j) {
      var posx = j * (pxSize + pxGap);

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
  var h = screen.viewPortH;
  var w = screen.viewPortW;

  var pxh = screen.height;
  var pxw = screen.width;

  final pictureRecorder = PictureRecorder();

  var canvas = Canvas(pictureRecorder, Rect.fromLTWH(0, 0, w, h));

  var paint = Paint()..color = color;

  var pxSize = screen.getSpritePixelSize();
  var pxGap = screen.getSpritePixelGap();

  for (var i = 0; i < pxh; ++i) {
    var posy = i * (pxSize + pxGap);
    for (var j = 0; j < pxw; ++j) {
      var posx = j * (pxSize + pxGap);

      canvas.drawRect(Rect.fromLTWH(posx, posy, pxSize, pxSize), paint);
    }
  }

  var picture = pictureRecorder.endRecording();
  var image = await picture.toImage(w.floor(), h.floor());

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

Future<PixelLoadResult> loadPixelizedImageFromAssets(
    Screen screen, String assetName) async {
  final byteData = await rootBundle.load('assets/images/$assetName');

  var image = img.PngDecoder().decode(byteData.buffer.asUint8List());

  if (image == null) {
    return PixelLoadResult();
  }

  var pxSize = screen.getSpritePixelSize();
  var pxGap = screen.getSpritePixelGap();

  var h = (image.height * (pxSize + pxGap)).toInt();
  var w = (image.width * (pxSize + pxGap)).toInt();

  final pictureRecorder = PictureRecorder();

  var canvas =
      Canvas(pictureRecorder, Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()));

  var pixel = image.getPixelSafe(0, 0);
  for (var i = 0; i < image.height; ++i) {
    var posy = i * (pxSize + pxGap);
    for (var j = 0; j < image.width; ++j) {
      var posx = j * (pxSize + pxGap);

      image.getPixelSafe(j, i, pixel);

      if (pixel == img.Pixel.undefined) {
        continue;
      }

      var color = Color.fromARGB(
        pixel.a.toInt(),
        pixel.r.toInt(),
        pixel.g.toInt(),
        pixel.b.toInt(),
      );

      var paint = Paint()..color = color;

      canvas.drawRect(Rect.fromLTWH(posx, posy, pxSize, pxSize), paint);
    }
  }

  var picture = pictureRecorder.endRecording();
  var retImage = await picture.toImage(w, h);

  var by = await retImage.toByteData();

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

class PixelLoadResult {
  bool success = false;
  PixelData? data;
}
