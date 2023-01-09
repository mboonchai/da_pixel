import 'package:da_pixel/main.dart';
import 'package:da_pixel/pixel.dart';
import 'package:da_pixel/pixels_loader/base.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

class Background extends SpriteComponent with HasGameRef<SpaceShooterGame> {
  final Color color;

  Background({
    this.color = const Color(0xFF111111),
    super.position,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    PixelData? pixels;
    var result = await loadBackground(gameRef.screen, color: color);
    if (result.success && result.data != null) {
      pixels = result.data!;
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
}
