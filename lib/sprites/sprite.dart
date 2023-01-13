import 'package:da_pixel/main.dart';
import 'package:da_pixel/pixel.dart';
import 'package:da_pixel/pixels_loader/base.dart';
import 'package:da_pixel/screen/pixel_position_support.dart';
import 'package:da_pixel/sprites_cache/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

abstract class DaPixelSpriteComponent extends SpriteComponent with HasGameRef<DaPixel>,PixelPositionSupport  {
  final Vector2 screenPosition;

  DaPixelSpriteComponent({required this.screenPosition,super.angle});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

     position = calcPositionFromScreen(gameRef.screen,screenPosition);

     //print("position $position");
    //sprite not handle the rotate...
    // if(Config.rotateScreen) {
    //     angle = pi/2;

    // }
  }
  
}


abstract class DaPixelSpriteGroupComponent<T> extends SpriteGroupComponent<T> with HasGameRef<DaPixel>,PixelPositionSupport  {

  final Vector2 screenPosition;

  DaPixelSpriteGroupComponent({required this.screenPosition,super.angle });

  @override
  Future<void>? onLoad() async {
     await super.onLoad();
     position = calcPositionFromScreen(gameRef.screen,screenPosition);
  }

  Future<Image> fromPixelData(PixelData data) async {
    return ImageExtension.fromPixels(data.data!, data.width, data.height);
  }

  Future<PixelLoadResult> Function() loadAlphaNumFromCache(String char,Color color) {

    return () async => loadAndCache("alphanum_${char}_$color",() async => await loadAlphaNum(gameRef.screen, char,  color: color) );
  }

}
