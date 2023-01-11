
import 'dart:math';

import 'package:da_pixel/config.dart';
import 'package:da_pixel/main.dart';
import 'package:da_pixel/screen/screen.dart';
import 'package:flame/components.dart';

class DaPixelSpriteComponent extends SpriteComponent with HasGameRef<DaPixel>,PixelPositionSupport  {
  final Vector2 screenPosition;

  DaPixelSpriteComponent({required this.screenPosition});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

     position = calcPositionFromScreen(gameRef.screen,screenPosition);
    
    if(Config.rotateScreen) {
        angle = pi/2;

    }
  }
  
}

mixin PixelPositionSupport  {
  
  Vector2 calcPositionFromScreen(Screen screen, Vector2 screenPosition) {
    return screen.getPositionFromScreen(screenPosition);
  }

} 