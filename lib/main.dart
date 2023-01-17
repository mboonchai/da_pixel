import 'package:da_pixel/app/clock.dart';
import 'package:da_pixel/screen/screen.dart';
import 'package:da_pixel/sprites/background.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import 'app/app.dart';
import 'config.dart';
import 'pixel.dart';
import 'sprites_cache/cache.dart';


class DaPixel extends FlameGame with PanDetector, DoubleTapDetector {
  late Background background;
  // late Numbers char;
  // late Char char2;

  // Char? char3;
  late Screen _screen;

  late List<DaPixelApp> apps;
  int curApp = -1;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    var viewportSize = Config.useLogicalSize?Config.logicalSize:size;

    _screen = Screen(viewportSize,PixelResolution.low);


    await precache(_screen);

    // char =Numbers(screenPosition: Vector2(0,0));
    // char2 = Char(characterCode: "2", color: Colors.white, screenPosition: Vector2(0, 7));

    apps = [
      createClockShowSeconds(viewportSize),
      createClock(viewportSize),
      createBigClock(viewportSize),
    ];

    camera.viewport = FixedResolutionViewport(_screen.getViewPort());

     background = Background(position: Vector2(0, 0), screen: _screen);

    // //player = Player();
     //add(background);

    if (apps.isNotEmpty) {
      add(apps[0]);
      curApp = 0;
    }

    //add(char);
    //add(char2);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    //char.move(info.delta.game);
    // char2.move(info.delta.game);

    // if (char3 != null) {
    //   char3!.move(info.delta.game);
    // }
  }

  @override
  void onDoubleTap() {
    super.onDoubleTap();

    var newApp = (curApp + 1) % apps.length;

    if (newApp != curApp) {
      remove(apps[curApp]);
      add(apps[newApp]);

      curApp = newApp;
    }

    // if (char3 != null) {
    //   return;
    // }

    // char3 = Char(
    //     characterCode: "1", color: Colors.white, screenPosition: Vector2(4, 0));
    // add(char3!);

    // char.current = NumberState.number_5;
  }

  @override
  @mustCallSuper
  void update(double dt) {
    super.update(dt);
  }
}

Future<void> precache(Screen screen) async {
  var textcolor = Colors.white;
  var textsize =  CharSize.small;

  await preCacheSprites({
    "alphanum_0_${textcolor}_$textsize": () async =>
        await loadAlphaNum(screen, "0", color: textcolor,size: textsize),
    "alphanum_1_${textcolor}_$textsize": () async =>
        await loadAlphaNum(screen, "1", color: textcolor,size: textsize),
    "alphanum_2_${textcolor}_$textsize": () async =>
        await loadAlphaNum(screen, "2", color: textcolor,size: textsize),
    "alphanum_3_${textcolor}_$textsize": () async =>
        await loadAlphaNum(screen, "3", color: textcolor,size: textsize),
    "alphanum_4_${textcolor}_$textsize": () async =>
        await loadAlphaNum(screen, "4", color: textcolor,size: textsize),
    "alphanum_5_${textcolor}_$textsize": () async =>
        await loadAlphaNum(screen, "5", color: textcolor,size: textsize),
    "alphanum_6_${textcolor}_$textsize": () async =>
        await loadAlphaNum(screen, "6", color: textcolor,size: textsize),
    "alphanum_7_${textcolor}_$textsize": () async =>
        await loadAlphaNum(screen, "7", color: textcolor,size: textsize),
    "alphanum_8_${textcolor}_$textsize": () async =>
        await loadAlphaNum(screen, "8", color: textcolor,size: textsize),
    "alphanum_9_${textcolor}_$textsize": () async =>
        await loadAlphaNum(screen, "9", color: textcolor,size: textsize),
  });
}

void main() {
  runApp(GameWidget(game: DaPixel()));

  //   windowManager.waitUntilReadyToShow().then((_) async{
  //           await windowManager.setAsFrameless();

  // });

}
