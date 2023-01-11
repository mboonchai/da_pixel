import 'package:da_pixel/screen/screen.dart';
import 'package:da_pixel/sprites/background.dart';
import 'package:da_pixel/sprites/char.dart';
import 'package:da_pixel/sprites/numbers.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

import 'pixel.dart';
import 'sprites_cache/cache.dart';

class DaPixel extends FlameGame with PanDetector, DoubleTapDetector {
  //late Player player;
  late Background background;
  late Numbers char;
  late Char char2;
  Char? char3;
  late Screen screen;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    screen = Screen(size);
    camera.viewport = FixedResolutionViewport(screen.getViewPort());

    await precache(screen);

    char =Numbers(screenPosition: Vector2(0,0));
    char2 = Char(characterCode: "2", color: Colors.white, screenPosition: Vector2(0, 7));
    background = Background(screenPosition: Vector2(0, 0));

    //player = Player();
    add(background);
    add(char);
    add(char2);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    //char.move(info.delta.game);
    char2.move(info.delta.game);

    if (char3 != null) {
      char3!.move(info.delta.game);
    }
  }

  @override
  void onDoubleTap() {
    super.onDoubleTap();
    if (char3 != null) {
      return;
    }

    char3 = Char(
        characterCode: "1", color: Colors.white, screenPosition: Vector2(4, 0));
    add(char3!);

    char.current = NumberState.number_5;
  }

  @override
  @mustCallSuper
  void update(double dt) {
    super.update(dt);
  }
}

Future<void> precache(Screen screen) async {
  var textcolor = Colors.white;

  await preCacheSprites(
     {
       "alphanum_0_$textcolor" : () async => await loadAlphaNum(screen, "0",  color: textcolor),
       "alphanum_1_$textcolor" : () async => await loadAlphaNum(screen, "1",  color: textcolor),
       "alphanum_2_$textcolor" : () async => await loadAlphaNum(screen, "2",  color: textcolor),
       "alphanum_3_$textcolor" : () async => await loadAlphaNum(screen, "3",  color: textcolor),
       "alphanum_4_$textcolor" : () async => await loadAlphaNum(screen, "4",  color: textcolor),
       "alphanum_5_$textcolor" : () async => await loadAlphaNum(screen, "5",  color: textcolor),
       "alphanum_6_$textcolor" : () async => await loadAlphaNum(screen, "6",  color: textcolor),
       "alphanum_7_$textcolor" : () async => await loadAlphaNum(screen, "7",  color: textcolor),
       "alphanum_8_$textcolor" : () async => await loadAlphaNum(screen, "8",  color: textcolor),
       "alphanum_9_$textcolor" : () async => await loadAlphaNum(screen, "9",  color: textcolor),
     }
  );
}

void main() {
  runApp(GameWidget(game: DaPixel()));
}
