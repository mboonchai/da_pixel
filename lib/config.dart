import 'package:flame/extensions.dart';

class Config {

    Config._();
    //[1920 x 480]
    // pixel: 40 x 10,  64 x 16
    // size: 40(dot)+8(gap) ~ 5:1,  25(dot) + 5(gap) ~ 5:1
    static int rotate = 90; //0, 90, 180, 270

    static bool forceScreenRatio = true; //if not force --> use windows size
    static Vector2 screenRatio = Vector2(1920,480);

    static SpriteCacheSize spriteCacheSize = SpriteCacheSize.reduced; //reduced = 5(dot) + 1(gap) size , real = pixelSize + pixelGap
    static double gapSize = 0.2;  //gapSize is LogicalSize, should * 5 = integer
    static double reducedSpriteCachePixelSize = 5.0; //

    //for DaPixelSpriteGroupComponent
    static double transitionDuration = 0.5;

}

enum SpriteCacheSize {
  reduced,
  real,
}


//number of logical row on the screen
class PixelResolution {
  static double low = 10;
  static double high = 16;

  PixelResolution._();
}