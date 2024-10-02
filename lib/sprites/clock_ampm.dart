import 'package:da_pixel/pixels/pixel.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

import 'sprite.dart';

enum AmPmState {
  am,
  pm,
}

class ClockAmPm extends DaPixelSpriteGroupComponent<AmPmState> {
  final Color color;
  final CharSize textSize;

  ClockAmPm(
      {this.color = const Color(0xffffffff),
       this.textSize = CharSize.small,
      required super.screenPosition,
      required super.screen,
      super.angle});

  @override
  Future<void>? onLoad() async {
    await super.onLoad();

    var spriteData = [
      await loadWordFromCache("\u009AAM", color,size: textSize)(),
      await loadWordFromCache("\u009APM", color,size: textSize)(),
    ];

    //use max size of am or pm
    var size = Vector2.zero();
    for(var sprite in spriteData) {
      if(sprite.data!.width > size.x) {
        size.x = sprite.data!.width.toDouble();
      }
      if(sprite.data!.height > size.y) {
        size.y = sprite.data!.height.toDouble();
      }
    }

    size = screen.calcSpriteSize(size.x, size.y);
 
    width = size.x;
    height = size.y;

    sprites = {
      AmPmState.am: Sprite(await fromPixelData(spriteData[0].data!)),
      AmPmState.pm: Sprite(await fromPixelData(spriteData[1].data!)),
    };
    current = AmPmState.am;
  }
}
