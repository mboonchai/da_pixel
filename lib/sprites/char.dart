import 'package:da_pixel/main.dart';
import 'package:da_pixel/pixel.dart';
import 'package:da_pixel/pixels_loader/base.dart';
import 'package:da_pixel/sprites_cache/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'base.dart';

class Char extends DaPixelSpriteComponent with HasGameRef<SpaceShooterGame>  {
  final String characterCode;
  final Color color;

  Char({
    required this.characterCode,
    required this.color,
    super.position,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    var cache = getCache();
    var key = "${characterCode}_$color";
    PixelData? pixels;

    if (cache.has(key)) {
      pixels = cache.get(key);
    } else {
      var result = await loadAlphaNum(gameRef.screen, characterCode,  color: color);
      if (result.success && result.data != null) {
        pixels = result.data!;

        cache.set(key, pixels);

      }
    }

    if (pixels != null) {
      var img = await ImageExtension.fromPixels(
          pixels.data!, pixels.width, pixels.height);
      sprite = Sprite(img);
      
      var size = gameRef.screen.calcSpriteSize(pixels.width.toDouble(),pixels.height.toDouble());

      width =  size.x;
      height =  size.y;

    } else {
      width = 0;
      height = 0;
    }

    
  }

  void move(Vector2 delta) {
    position.add(delta);
  }
}
