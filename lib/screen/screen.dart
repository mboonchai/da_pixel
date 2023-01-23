import 'package:da_pixel/config.dart';
import 'package:flame/components.dart';
import 'dart:core';

//Screen we use this to manually calculate screen position
class Screen {



  late double offsetPixelTop; //physical offset
  late double offsetPixelLeft; //physical offset
  late double pixelSize; //physical pixel size
  late double pixelGap; //physical pixel gap

  late double width; //logical w
  late double height; //logical h

  late double viewPortW;
  late double viewPortH;

  /// Screen
  /// ratio is Width/Height
  /// numPixelY is number of logical pixel of Y axis , number of logical pixel of X axis will be = ratio*numPixelY
  factory Screen(Vector2 screenSize, double numPixelY) {

 
    //not singleton!
    var instance = Screen._();

    var w = screenSize.x;
    var h = screenSize.y;

    var numPixelX = Config.ratio * numPixelY;

    if (!Config.rotateScreen) {
      
      var useW = (w / numPixelX).floorToDouble() * numPixelX;
      var useH = (w / numPixelX).floorToDouble() * numPixelY;


      instance.offsetPixelLeft = (w - useW) / 2;
      instance.offsetPixelTop = (h - useH) / 2;

      instance.pixelSize = (w / numPixelX).floorToDouble() / (1+Config.gapSize);
      instance.pixelGap = instance.pixelSize * Config.gapSize;


      instance.viewPortW =
          (w / numPixelX).floorToDouble() * numPixelX - 
              instance.pixelGap;
      instance.viewPortH =
          (w / numPixelX).floorToDouble() * numPixelY -
              instance.pixelGap;
    } else {
      var useH = (h / numPixelY).floorToDouble() * numPixelY;
      var useW = (h / numPixelY).floorToDouble() * numPixelX;

      instance.offsetPixelLeft = (w - useW) / 2;
      instance.offsetPixelTop = (h - useH) / 2;

      instance.pixelSize = (h / numPixelY).floorToDouble() /  (1+Config.gapSize);
      instance.pixelGap = instance.pixelSize * Config.gapSize;

      instance.viewPortW =
          (h / numPixelY).floorToDouble() * numPixelX -
              instance.pixelGap;
      instance.viewPortH =
          (h / numPixelY).floorToDouble() * numPixelY -
              instance.pixelGap;
    }

    instance.width = numPixelX;
    instance.height = numPixelY;

    //if rotate do it here...
    if (Config.rotateScreen) {
      var tmp = 0.0;

      tmp = instance.offsetPixelLeft;
      instance.offsetPixelLeft = instance.offsetPixelTop;
      instance.offsetPixelTop = tmp;

      tmp = instance.viewPortW;
      instance.viewPortW = instance.viewPortH;
      instance.viewPortH = tmp;

      tmp = instance.width;
      instance.width = instance.height;
      instance.height = tmp;
    }


    return instance;
  }

  Screen._();

  Vector2 getViewPort() {
    return Vector2(viewPortW, viewPortH);
  }

  //x,y is logical/screen (top,left)
  Vector2 getPosition(int x, int y) {
    return Vector2(
      Config.rotateScreen
          ? (viewPortW - (y * (pixelSize + pixelGap)))
          : (x * (pixelSize + pixelGap)),
      Config.rotateScreen
          ? ((x * (pixelSize + pixelGap)))
          : (y * (pixelSize + pixelGap)),
    );
  }

  //use with sprite only
  Vector2 getPositionFromScreen(Vector2 pos) {
    return Vector2(
      (pos.x * (pixelSize + pixelGap)),
      (pos.y * (pixelSize + pixelGap)),
    );
  }

  //use with positioncomponent only
  Vector2 getPositionFromScreenWithRotate(Vector2 pos) {
    return Vector2(
      Config.rotateScreen
          ? (viewPortW - (pos.y * (pixelSize + pixelGap)))
          : (pos.x * (pixelSize + pixelGap)),
      Config.rotateScreen
          ? ((pos.x * (pixelSize + pixelGap)))
          : (pos.y * (pixelSize + pixelGap)),
    );
  }

  //sprite size may be real size or reduced size
  Vector2 calcSpriteSize(double width, double height) {

    var netweight = (1 + Config.gapSize)*5;

    return Vector2(
        Config.cacheResolution <= 0
            ? (width)
            : (width * (pixelSize + pixelGap) / netweight),
        Config.cacheResolution <= 0
            ? (height)
            : (height * (pixelSize + pixelGap) / netweight));
  }

  Vector2 calcSizeFromPixel(double pixelWidth, double pixelHeight) {
        var netweight = (1 + Config.gapSize)*5;

    return Vector2(width * (pixelSize + pixelGap) / netweight,
        height * (pixelSize + pixelGap) / netweight);
  }

  double getSpritePixelSize() {
    return Config.cacheResolution <= 0
        ? pixelSize
        : (Config.cacheResolution * 5.0);
  }

  double getSpritePixelGap() {
    return Config.cacheResolution <= 0
        ? pixelGap
        : (Config.cacheResolution * 5.0 * Config.gapSize);
  }
}

Screen createLowResScreen(Vector2 screenSize) {
  return Screen(screenSize, PixelResolution.low);
}

Screen createHighResScreen(Vector2 screenSize) {
  return Screen(screenSize, PixelResolution.high);
}