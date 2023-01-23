import 'package:da_pixel/pixel.dart';
import 'package:da_pixel/pixels_loader/base.dart';
import 'package:da_pixel/sprites/sprite.dart';
import 'package:da_pixel/sprites_cache/cache.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';

class CommonSpriteComponent extends DaPixelSpriteComponent {
  
  final String assetName;
 
 
  CommonSpriteComponent({
    required this.assetName,
    required super.screen,
    required super.screenPosition,
  });

  
  @override
  Future<void> onLoad() async {
    await super.onLoad();

   
    var cache = getCache();
    var key = assetName;

    PixelData? pixels;

    if (cache.has(key)) {
      pixels = cache.get(key);
    } else {
      var result = await loadPixelizedImageFromAssets(screen, assetName);
      if (result.success && result.data != null) {
        pixels = result.data!;

        cache.set(key, pixels);
      }
    }

    if (pixels != null) {
      var img = await ImageExtension.fromPixels(
          pixels.data!, pixels.width, pixels.height);
      sprite = Sprite(img);

      var size = screen.calcSpriteSize(
          pixels.width.toDouble(), pixels.height.toDouble());

      width = size.x;
      height = size.y;
    } else {
      width = 0;
      height = 0;
    }
  }


}