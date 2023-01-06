import 'package:da_pixel/config.dart';
import 'package:da_pixel/main.dart';
import 'package:da_pixel/pixel.dart';
import 'package:da_pixel/pixels_loader/base.dart';
import 'package:da_pixel/screen/screen.dart';
import 'package:da_pixel/sprites_cache/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

class Char extends SpriteComponent with HasGameRef<SpaceShooterGame>  {
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
      var result = await loadAlphaNum(characterCode,gameRef.screen.pixelSize,gameRef.screen.pixelGap,  color: color);
      if (result.success && result.data != null) {
        pixels = result.data!;

        cache.set(key, pixels);

      }
    }

    if (pixels != null) {
      var img = await ImageExtension.fromPixels(
          pixels.data!, pixels.width, pixels.height);
      sprite = Sprite(img);

      width = pixels.width.toDouble();
      height = pixels.height.toDouble();

      if(Config.rotateScreen) {
        position.x = position.x -width;
      }

    } else {
      width = 0;
      height = 0;
    }
  }

  void move(Vector2 delta) {
    position.add(delta);
  }
}
