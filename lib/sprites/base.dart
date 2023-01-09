
import 'dart:math';

import 'package:da_pixel/config.dart';
import 'package:flame/components.dart';

class DaPixelSpriteComponent extends SpriteComponent
{

  DaPixelSpriteComponent({
    super.position,
  });


  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    if(Config.rotateScreen) {
        angle = pi/2;

    }
  }
  
}