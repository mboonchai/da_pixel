import 'package:da_pixel/screen/screen.dart';
import 'package:da_pixel/sprites/background.dart';
import 'package:da_pixel/sprites/char.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

// class Player extends SpriteComponent with HasGameRef<SpaceShooterGame> {
//   @override
//   Future<void> onLoad() async {
//     await super.onLoad();

//     var result = await loadAlphaNum("P");
//     if (!result.success || result.data == null) {
//       sprite = await gameRef.loadSprite('player-sprite.png');
//     } else {
//       var pixels = result.data!;
//       var img = await ImageExtension.fromPixels(
//           pixels.data!, pixels.width, pixels.height);
//       sprite = Sprite(img);
//       width = pixels.width.toDouble();
//       height = pixels.height.toDouble();
//     }

//     position = gameRef.size / 2;

//     anchor = Anchor.center;
//   }

//   void move(Vector2 delta) {
//     position.add(delta);
//   }
// }

class SpaceShooterGame extends FlameGame with PanDetector,DoubleTapDetector {
  //late Player player;
  late Background background;
  late Char char;
  late Char char2;
  Char? char3;
  late Screen screen;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    screen = Screen(size);
    camera.viewport = FixedResolutionViewport(screen.getViewPort()); 


    char = Char(characterCode: "1", color: Colors.white, position: screen.getPosition(0, 0));
    char2 = Char(characterCode: "2", color: Colors.white, position: screen.getPosition(0, 7));

    background = Background(position: Vector2(0,0));

    //player = Player();
    add(background);
    add(char);
    add(char2);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    char.move(info.delta.game);
    char2.move(info.delta.game);

    if(char3!=null) {
      char3!.move(info.delta.game);
    }
  }

    @override void onDoubleTap() {
    super.onDoubleTap();
    if(char3!=null) {
      return;
    }

    char3 = Char(characterCode: "1", color: Colors.white, position:  screen.getPosition(4, 0));
    add(char3!);

  }

  @override
  @mustCallSuper
  void update(double dt) {
    super.update(dt);
  }
}

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}
