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
  factory Screen(Vector2 screenSize) {
    if (_instance != null) {
      return _instance!;
    }

    _instance = Screen._();

    var w = screenSize.x;
    var h = screenSize.y;

    var numPixelX = Config.ratio * Config.numPixelY;

    if (Config.ratio > 1) {
      var useW = (w / numPixelX).floorToDouble() * numPixelX;
      var useH = (w / numPixelX).floorToDouble() * Config.numPixelY;

      _instance!.offsetPixelLeft = (w - useW) / 2;
      _instance!.offsetPixelTop = (h - useH) / 2;

      _instance!.pixelSize = (w / numPixelX).floorToDouble() / 1.2;
      _instance!.pixelGap = _instance!.pixelSize * 0.2;

      _instance!.viewPortW =
          (w / numPixelX).floorToDouble() * numPixelX - _instance!.pixelGap;
      _instance!.viewPortH =
          (w / numPixelX).floorToDouble() * Config.numPixelY -
              _instance!.pixelGap;
    } else {
      var useH = (h / Config.numPixelY).floorToDouble() * Config.numPixelY;
      var useW = (h / Config.numPixelY).floorToDouble() / 1.2 * numPixelX;

      _instance!.offsetPixelLeft = (w - useW) / 2;
      _instance!.offsetPixelTop = (h - useH) / 2;

      _instance!.pixelSize = (h / Config.numPixelY).floorToDouble() / 1.2;
      _instance!.pixelGap = _instance!.pixelSize * 0.2;

      _instance!.viewPortW =
          (h / Config.numPixelY).floorToDouble() * numPixelX -
              _instance!.pixelGap;
      _instance!.viewPortH =
          (h / Config.numPixelY).floorToDouble() * Config.numPixelY -
              _instance!.pixelGap;
    }

    _instance!.width = numPixelX;
    _instance!.height = Config.numPixelY;

    //if rotate do it here...
    if (Config.rotateScreen) {
      var tmp = 0.0;

      tmp = _instance!.offsetPixelLeft;
      _instance!.offsetPixelLeft = _instance!.offsetPixelTop;
      _instance!.offsetPixelTop = tmp;

      tmp = _instance!.viewPortW;
      _instance!.viewPortW = _instance!.viewPortH;
      _instance!.viewPortH = tmp;

      tmp = _instance!.width;
      _instance!.width = _instance!.height;
      _instance!.height = tmp;
    }

    return _instance!;
  }

  Screen._();

  static Screen? _instance;

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

  Vector2 getPositionFromScreen(Vector2 pos) {
    return Vector2(
      Config.rotateScreen
          ? (viewPortW - (pos.y * (pixelSize + pixelGap)))
          : (pos.x * (pixelSize + pixelGap)),
      Config.rotateScreen
          ? ((pos.x * (pixelSize + pixelGap)))
          : (pos.y * (pixelSize + pixelGap)),
    );
  }

  Vector2 calcSpriteSize(double width,double height) {
    return Vector2(
      Config.cacheResolution<=0?(width):(width * (pixelSize+pixelGap)/6),
      Config.cacheResolution<=0?(height):(height * (pixelSize+pixelGap)/6));
  }

  double getSpritePixelSize() {
    return Config.cacheResolution<=0?pixelSize:(Config.cacheResolution*5.0);
  }

 double getSpritePixelGap() {
    return Config.cacheResolution<=0?pixelGap:(Config.cacheResolution*1.0);
  }
}

