import 'package:da_pixel/pixel.dart';
import 'package:da_pixel/pixels_loader/base.dart';
import 'package:da_pixel/sprites_cache/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'sprite.dart';

class Char extends DaPixelSpriteComponent {
  final String characterCode;
  final Color color;
  final CharSize textSize;

  Char({
    required this.characterCode,
    this.color = const Color(0xffffffff),
    this.textSize = CharSize.small,
    required super.screen,
    required super.screenPosition,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    var cache = getCache();
    var key = "alphanum_${characterCode}_${color}_$textSize";
    PixelData? pixels;

    if (cache.has(key)) {
      pixels = cache.get(key);
    } else {
      var result = await loadAlphaNum(screen, characterCode,
          color: color, size: textSize);
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

  void move(Vector2 delta) {
    position.add(delta);
  }
}
