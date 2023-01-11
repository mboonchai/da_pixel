

import 'package:da_pixel/main.dart';
import 'package:da_pixel/pixel.dart';
import 'package:da_pixel/pixels_loader/base.dart';
import 'package:da_pixel/sprites_cache/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

import 'base.dart';

enum NumberState {
  number_0,
  number_1,
  number_2,
  number_3,
  number_4,
  number_5,
  number_6,
  number_7,
  number_8,
  number_9,
}

class Numbers extends SpriteGroupComponent<NumberState> with HasGameRef<DaPixel>,PixelPositionSupport  {
  final Vector2 screenPosition;
  final Color color;

  Numbers({this.color = const Color(0xffffffff), required this.screenPosition });

  @override
  Future<void>? onLoad() async {

    var spriteData = [
      await _loader("0")(),
      await _loader("1")(),
      await _loader("2")(),
      await _loader("3")(),
      await _loader("4")(),
      await _loader("5")(),
      await _loader("6")(),
      await _loader("7")(),
      await _loader("8")(),
      await _loader("9")(),
    ];

    var size = gameRef.screen.calcSpriteSize(spriteData[0].data!.width.toDouble(),spriteData[0].data!.height.toDouble());
    width =  size.x;
    height =  size.y;

    

    sprites = {
      NumberState.number_0: Sprite(await _fromPixelData(spriteData[0].data!)),
      NumberState.number_1: Sprite(await _fromPixelData(spriteData[1].data!)),
      NumberState.number_2: Sprite(await _fromPixelData(spriteData[2].data!)),
      NumberState.number_3: Sprite(await _fromPixelData(spriteData[3].data!)),
      NumberState.number_4: Sprite(await _fromPixelData(spriteData[4].data!)),
      NumberState.number_5: Sprite(await _fromPixelData(spriteData[5].data!)),
      NumberState.number_6: Sprite(await _fromPixelData(spriteData[6].data!)),
      NumberState.number_7: Sprite(await _fromPixelData(spriteData[7].data!)),
      NumberState.number_8: Sprite(await _fromPixelData(spriteData[8].data!)),
      NumberState.number_9: Sprite(await _fromPixelData(spriteData[9].data!)),

    };

    current = NumberState.number_0;
  }

  Future<Image> _fromPixelData(PixelData data) async {
    return ImageExtension.fromPixels(data.data!, data.width, data.height);
  }

  Future<PixelLoadResult> Function() _loader(String char) {

    return () async => loadAndCache("alphanum_${char}_$color",() async => await loadAlphaNum(gameRef.screen, char,  color: color) );
  }

}
