import 'package:da_pixel/config.dart';
import 'package:flame/components.dart';
import 'dart:math' as math;
import 'dart:core';

class Screen {


  late double offsetPixelTop;  //physical offset
  late double offsetPixelLeft;  //physical offset
  late double pixelSize;  //physical pixel size
  late double pixelGap;  //physical pixel gap

  late double width;  //logical w
  late double height; //logical h

  late double viewPortW;
  late double viewPortH;

  /// Screen
  /// ratio is Width/Height
  /// numPixelY is number of logical pixel of Y axis , number of logical pixel of X axis will be = ratio*numPixelY
  factory Screen(Vector2 screenSize) {

    if(_instance!=null) {
      return _instance!;
    }

    _instance = Screen._();
    
    var w = screenSize.x;
    var h = screenSize.y;

    var numPixelX = Config.ratio * Config.numPixelY;
    
    

    if(Config.ratio>1) {
      var useW = (w/numPixelX).floorToDouble() * numPixelX;
      var useH =  (w/numPixelX).floorToDouble() * Config.numPixelY;

      print("useW: ${useW}");
      print("w: ${w}");
      print("useH: ${useH}");
      print("h: ${h}");

      _instance!.offsetPixelLeft = (w - useW)/2;
      _instance!.offsetPixelTop =(h - useH)/2;

      _instance!.pixelSize = (w/numPixelX).floorToDouble() / 1.2;
      _instance!.pixelGap = _instance!.pixelSize * 0.2;

      _instance!.viewPortW = (w/numPixelX).floorToDouble() * numPixelX - _instance!.pixelGap;
      _instance!.viewPortH = (w/numPixelX).floorToDouble() * Config.numPixelY - _instance!.pixelGap;
      

    } else {
      var useH = (h/Config.numPixelY).floorToDouble() * Config.numPixelY;
      var useW = (h/Config.numPixelY).floorToDouble()/1.2 * numPixelX;

       _instance!.offsetPixelLeft = (w - useW)/2;
      _instance!.offsetPixelTop = (h - useH)/2;

      _instance!.pixelSize = (h/Config.numPixelY).floorToDouble() / 1.2;
      _instance!.pixelGap = _instance!.pixelSize * 0.2;

      _instance!.viewPortW = (h/Config.numPixelY).floorToDouble() * numPixelX - _instance!.pixelGap;
      _instance!.viewPortH = (h/Config.numPixelY).floorToDouble() * Config.numPixelY - _instance!.pixelGap;

    }

    _instance!.width = numPixelX;
    _instance!.height = Config.numPixelY;

    //if rotate do it here...
    if(Config.rotateScreen) {
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

    

    // print("pixelSize: ${_instance!.pixelSize}");
    // print("pixelGap: ${_instance!.pixelGap}");
    // print("offsetPixelTop: ${_instance!.offsetPixelTop}");
    // print("offsetPixelLeft: ${_instance!.offsetPixelLeft}");
    
    // print("width: ${_instance!.width}");
    // print("height: ${_instance!.height}");

    // print("viewPortW: ${_instance!.viewPortW}");
    // print("viewPortH: ${_instance!.viewPortH}");


    return _instance!;

  }

  Screen._();

  static Screen? _instance;


  Vector2 getViewPort() {
    return Vector2(viewPortW,viewPortH);
  }

  //x,y is logical (top,left)
  Vector2 getPosition(int x, int y) {
    return Vector2(
      Config.rotateScreen?(viewPortW - ( y * (pixelSize+pixelGap))):( x * (pixelSize+pixelGap)),
      Config.rotateScreen?(( x * (pixelSize+pixelGap))):( y * (pixelSize+pixelGap)),
    );
  }
}