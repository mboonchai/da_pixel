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
  /// nRow is number of logical pixel of Y axis , number of logical pixel of X axis will be = ratio*nRow
  factory Screen(Vector2 screenSize, double nRow) {
 
    //not singleton!
    var instance = Screen._();

    var w = screenSize.x;
    var h = screenSize.y;

    var nCol = screenSize.x/screenSize.y * nRow;

    if (!Config.rotateScreen) {
      
      var useW = (w / nCol).floorToDouble() * nCol;
      var useH = (w / nCol).floorToDouble() * nRow;


      instance.offsetPixelLeft = (w - useW) / 2;
      instance.offsetPixelTop = (h - useH) / 2;

      instance.pixelSize = (w / nCol).floorToDouble() / (1+Config.gapSize);
      instance.pixelGap = instance.pixelSize * Config.gapSize;


      instance.viewPortW =
          (w / nCol).floorToDouble() * nCol - 
              instance.pixelGap;
      instance.viewPortH =
          (w / nCol).floorToDouble() * nRow -
              instance.pixelGap;
    } else {
      var useH = (h / nRow).floorToDouble() * nRow;
      var useW = (h / nRow).floorToDouble() * nCol;

      instance.offsetPixelLeft = (w - useW) / 2;
      instance.offsetPixelTop = (h - useH) / 2;

      instance.pixelSize = (h / nRow).floorToDouble() /  (1+Config.gapSize);
      instance.pixelGap = instance.pixelSize * Config.gapSize;

      instance.viewPortW =
          (h / nRow).floorToDouble() * nCol -
              instance.pixelGap;
      instance.viewPortH =
          (h / nRow).floorToDouble() * nRow -
              instance.pixelGap;
    }

    instance.width = nCol;
    instance.height = nRow;

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

    var minPixel = (1 + Config.gapSize)*Config.reducedSpriteCachePixelSize;

    return Vector2(
        Config.spriteCacheSize == SpriteCacheSize.reduced
            ?(width * (pixelSize + pixelGap) / minPixel):
            (width),
        Config.spriteCacheSize  == SpriteCacheSize.reduced
            ? (height * (pixelSize + pixelGap) / minPixel)
            : (height)
    );
  }

  Vector2 calcSizeFromPixel(double pixelWidth, double pixelHeight) {
        var minPixel = (1 + Config.gapSize)*Config.reducedSpriteCachePixelSize;

    return Vector2(width * (pixelSize + pixelGap) / minPixel,
        height * (pixelSize + pixelGap) / minPixel);
  }

  double getSpritePixelSize() {
    return Config.spriteCacheSize == SpriteCacheSize.reduced
        ? Config.reducedSpriteCachePixelSize
        : pixelSize;
  }

  double getSpritePixelGap() {
    return Config.spriteCacheSize == SpriteCacheSize.reduced
        ? (Config.reducedSpriteCachePixelSize * Config.gapSize)
        :pixelGap;
  }
}

Screen createLowResScreen(Vector2 screenSize) {
  return Screen(screenSize, PixelResolution.low);
}

Screen createHighResScreen(Vector2 screenSize) {
  return Screen(screenSize, PixelResolution.high);
}