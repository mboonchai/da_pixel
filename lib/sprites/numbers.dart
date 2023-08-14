import 'package:da_pixel/pixel.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

import 'sprite.dart';


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
  number_notshow,
}

class Numbers extends DaPixelSpriteGroupComponent<NumberState> {
  final Color color;
  final CharSize textSize;

  Numbers({this.color = const Color(0xffffffff), 
    this.textSize = CharSize.small,
    required super.screen,
    required super.screenPosition,
    super.angle,
    super.transitionStep,
     });

  @override
  Future<void>? onLoad() async {
     await super.onLoad();
   
    var spriteData = [
      await loadAlphaNumFromCache("0",color,size:textSize)(),
      await loadAlphaNumFromCache("1",color,size:textSize)(),
      await loadAlphaNumFromCache("2",color,size:textSize)(),
      await loadAlphaNumFromCache("3",color,size:textSize)(),
      await loadAlphaNumFromCache("4",color,size:textSize)(),
      await loadAlphaNumFromCache("5",color,size:textSize)(),
      await loadAlphaNumFromCache("6",color,size:textSize)(),
      await loadAlphaNumFromCache("7",color,size:textSize)(),
      await loadAlphaNumFromCache("8",color,size:textSize)(),
      await loadAlphaNumFromCache("9",color,size:textSize)(),
      await loadAlphaNumFromCache(" ",color,size:textSize)(),
    ];

    var size = screen.calcSpriteSize(spriteData[0].data!.width.toDouble(),spriteData[0].data!.height.toDouble());
    width =  size.x;
    height =  size.y;

    

    sprites = {
      NumberState.number_0: Sprite(await fromPixelData(spriteData[0].data!)),
      NumberState.number_1: Sprite(await fromPixelData(spriteData[1].data!)),
      NumberState.number_2: Sprite(await fromPixelData(spriteData[2].data!)),
      NumberState.number_3: Sprite(await fromPixelData(spriteData[3].data!)),
      NumberState.number_4: Sprite(await fromPixelData(spriteData[4].data!)),
      NumberState.number_5: Sprite(await fromPixelData(spriteData[5].data!)),
      NumberState.number_6: Sprite(await fromPixelData(spriteData[6].data!)),
      NumberState.number_7: Sprite(await fromPixelData(spriteData[7].data!)),
      NumberState.number_8: Sprite(await fromPixelData(spriteData[8].data!)),
      NumberState.number_9: Sprite(await fromPixelData(spriteData[9].data!)),
      NumberState.number_notshow: Sprite(await fromPixelData(spriteData[10].data!)),

    };

    current = NumberState.number_0;
  }

}
