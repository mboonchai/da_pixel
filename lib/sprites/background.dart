
import 'package:da_pixel/pixels/pixel.dart';
import 'package:da_pixel/screen/screen.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';


//Screen is not dapixelsprite!
class Background extends SpriteComponent {
  final Color color;
  final Screen screen;

  Background({
    this.color = const Color(0xFF111111),
    required this.screen,
    required super.position,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    PixelData? pixels;
    var result = await loadBackground(screen, color: color);
    if (result.success && result.data != null) {
      pixels = result.data!;
    }

    if (pixels != null) {
      var img = await ImageExtension.fromPixels(
          pixels.data!, pixels.width, pixels.height);
      sprite = Sprite(img);

      var size = screen
          .calcSpriteSize(pixels.width.toDouble(), pixels.height.toDouble());

      width = size.x;
      height = size.y;

      //print("size $width , $height");
    } else {
      width = 0;
      height = 0;
    }
  }
}
