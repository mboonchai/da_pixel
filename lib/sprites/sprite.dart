import 'package:da_pixel/pixel.dart';
import 'package:da_pixel/pixels_loader/base.dart';
import 'package:da_pixel/screen/pixel_position_support.dart';
import 'package:da_pixel/screen/screen.dart';
import 'package:da_pixel/sprites_cache/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

abstract class DaPixelSpriteComponent extends SpriteComponent with PixelPositionSupport  {
  final Vector2 screenPosition;
  final Screen screen;

  DaPixelSpriteComponent({required this.screenPosition,required this.screen, super.angle});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

     position = calcPositionFromScreen(screen,screenPosition);

     //print("position $position");
    //sprite not handle the rotate...
    // if(Config.rotateScreen) {
    //     angle = pi/2;

    // }
  }
  
}


abstract class DaPixelSpriteGroupComponent<T> extends SpriteGroupComponent<T> with PixelPositionSupport  {
  final Vector2 screenPosition;
  final Screen screen;

  DaPixelSpriteGroupComponent({required this.screenPosition,required this.screen,super.angle });

  @override
  Future<void>? onLoad() async {
     await super.onLoad();
     position = calcPositionFromScreen(screen,screenPosition);
  }

  Future<Image> fromPixelData(PixelData data) async {
    return ImageExtension.fromPixels(data.data!, data.width, data.height);
  }

  Future<PixelLoadResult> Function() loadAlphaNumFromCache(String char,Color color,{CharSize size = CharSize.small}) {

    return () async => loadAndCache("alphanum_${char}_${color}_$size",() async => await loadAlphaNum(screen, char,  color: color,size: size) );
  }

  
  Future<PixelLoadResult> Function() loadWordFromCache(String word,Color color,{CharSize size = CharSize.small}) {

    return () async => loadAndCache("word_${word}_${color}_$size",() async => await loadWords(screen, word,  color: color,size: size) );
  }


}
