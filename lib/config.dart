import 'package:flame/extensions.dart';

class Config {

    Config._();
    //1920 x 480
    // pixel: 40 x 10,  64 x 16
    // size: 40(dot)+8(gap) ~ 5:1,  25(dot) + 5(gap) ~ 5:1

    static bool useLogicalSize = true;
    static Vector2 logicalSize = Vector2(1920,480);

    static double ratio = 4;
    static double gapSize = 0.2;
    static bool rotateScreen = false;  //rotate 90 degree clock wise
    static int cacheResolution = 1; //1 = 5(dot) + 1(gap) size , 0 = pixelSize + pixelGap

}

class PixelResolution {
  static double low = 10;
  static double high = 16;

  PixelResolution._();
}