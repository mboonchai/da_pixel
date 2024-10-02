import 'package:da_pixel/pixels/pixel.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

import 'sprite.dart';

enum BlinkState {
  on,
  off,
}

class ClockSeparator extends DaPixelSpriteGroupComponent<BlinkState> {
  final Color color;
  final CharSize textSize;

  ClockSeparator(
      {this.color = const Color(0xffffffff),
       this.textSize = CharSize.small,
      required super.screenPosition,
      required super.screen,
      super.angle});

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    var spriteData = [
      await loadAlphaNumFromCache(":", color,size: textSize)(),
      await loadAlphaNumFromCache("\u009A", color,size: textSize)(),
    ];

    var size = screen.calcSpriteSize(
        spriteData[0].data!.width.toDouble(),
        spriteData[0].data!.height.toDouble());
    width = size.x;
    height = size.y;

    sprites = {
      BlinkState.on: Sprite(await fromPixelData(spriteData[0].data!)),
      BlinkState.off: Sprite(await fromPixelData(spriteData[1].data!)),
    };
    current = BlinkState.on;
  }
}
