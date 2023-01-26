import 'dart:math';

import 'package:da_pixel/config.dart';
import 'package:da_pixel/screen/pixel_position_support.dart';
import 'package:da_pixel/screen/screen.dart';
import 'package:da_pixel/sprites/background.dart';
import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

abstract class DaPixelApp extends PositionComponent with PixelPositionSupport  {
  final Screen screen;
  final Vector2 screenPosition;
  final double period;  //period that will actually updated
  double _curDT = -0.01;  //last update pass
  int _curTick = 0;  //internal usage --> count period circle 0,1,2,3

  DaPixelApp({required this.screenPosition,
  required this.screen, this.period = 0.5});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

     position = calcPositionFromScreenWithRotate(screen,screenPosition);
    
    if(Config.rotateScreen) {
        angle = pi/2;
    }

    await add (Background(screen: screen, position: Vector2(0, 0)));
  } 


  @override
  @mustCallSuper
  void update(double dt) {
    super.update(dt);

    if(_curDT<0) {
      _curDT =0;
      _curTick = (_curTick+1)%8;
      updateApp(_curTick);
      return;
    }

     _curDT += dt;
     if( _curDT > period) {
      _curDT = 0;
      _curTick = (_curTick+1)%8;
       updateApp(_curTick);
     }


  }

  Future<void> updateApp(int tick);
}


abstract class Updatable {
  Future<void> updateApp(int tick);
}

abstract class DaPixelWidget extends PositionComponent with PixelPositionSupport implements Updatable{
  final Vector2 screenPosition;
  final Screen screen;

  DaPixelWidget({required this.screenPosition, required this.screen});
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    position = calcPositionFromScreen(screen, screenPosition);


  }
}

