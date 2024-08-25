import 'package:da_pixel/app/simplecalendar.dart';
import 'package:da_pixel/app/simpleclock.dart';
import 'package:da_pixel/screen/screen.dart';
import 'package:flame/camera.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'app/app.dart';
import 'config.dart';
import 'dart:math';

class DaPixel extends FlameGame with PanDetector, DoubleTapDetector {
  @override
  final world = World();
  late final CameraComponent _camera;

  late Screen _screen;

  late List<DaPixelApp> apps;
  int curApp = -1;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    var viewportSize = Config.forceScreenRatio ? Config.screenRatio : size;
    _screen = Screen(viewportSize, PixelResolution.low);
    _camera = createCamera(world, viewportSize);

    apps = [
      createClockShowSeconds(viewportSize),
      createClock(viewportSize),
      createBigClock(viewportSize),
      createBigCalendarClock(viewportSize),
      createCalendarClock(viewportSize)
    ];


    for (var app in apps) {
      await app.precache(_screen);
    }

    if (apps.isNotEmpty) {
      world.add(apps[0]);
      curApp = 0;
    }

    addAll([world,_camera]);

  }

  @override
  void onPanUpdate(DragUpdateInfo info) {

  }

  @override
  void onDoubleTap() {
    super.onDoubleTap();

    var newApp = (curApp + 1) % apps.length;

    if (newApp != curApp) {
      world.remove(apps[curApp]);
      world.add(apps[newApp]);

      curApp = newApp;
    }

  }

  @override
  @mustCallSuper
  void update(double dt) {
    super.update(dt);
  }
}

CameraComponent createCamera(World world, Vector2 viewportSize) {
  CameraComponent camera;

   if(Config.rotate == 180) {
    camera = CameraComponent.withFixedResolution(width: viewportSize.x, height: viewportSize.y,world: world);
    camera.viewfinder.anchor = Anchor.topLeft;
    camera.viewfinder.angle = -pi;
    camera.viewfinder.position = Vector2(viewportSize.x,viewportSize.y);

  } else if(Config.rotate == 90){  
    camera = CameraComponent.withFixedResolution(width: viewportSize.y, height: viewportSize.x,world: world);
    camera.viewfinder.anchor = Anchor.topLeft;
    camera.viewfinder.angle = -pi/2;
    camera.viewfinder.position = Vector2(0,viewportSize.y);
  }else if(Config.rotate == 270){  
    camera = CameraComponent.withFixedResolution(width: viewportSize.y, height: viewportSize.x,world: world);
    camera.viewfinder.anchor = Anchor.topLeft;
    camera.viewfinder.angle = pi/2;
    camera.viewfinder.position = Vector2(viewportSize.x,0);
  } else {
    camera =   CameraComponent.withFixedResolution(width: viewportSize.x, height: viewportSize.y,world: world);
    camera.viewfinder.anchor = Anchor.topLeft;
  }

  return camera;
}

// Future<void> precache(Screen screen) async {
//   var textcolor = Colors.white;
//   var textsize =  CharSize.small;

//   await preCacheSprites({
//     "alphanum_0_${textcolor}_$textsize": () async =>
//         await loadAlphaNum(screen, "0", color: textcolor,size: textsize),
//     "alphanum_1_${textcolor}_$textsize": () async =>
//         await loadAlphaNum(screen, "1", color: textcolor,size: textsize),
//     "alphanum_2_${textcolor}_$textsize": () async =>
//         await loadAlphaNum(screen, "2", color: textcolor,size: textsize),
//     "alphanum_3_${textcolor}_$textsize": () async =>
//         await loadAlphaNum(screen, "3", color: textcolor,size: textsize),
//     "alphanum_4_${textcolor}_$textsize": () async =>
//         await loadAlphaNum(screen, "4", color: textcolor,size: textsize),
//     "alphanum_5_${textcolor}_$textsize": () async =>
//         await loadAlphaNum(screen, "5", color: textcolor,size: textsize),
//     "alphanum_6_${textcolor}_$textsize": () async =>
//         await loadAlphaNum(screen, "6", color: textcolor,size: textsize),
//     "alphanum_7_${textcolor}_$textsize": () async =>
//         await loadAlphaNum(screen, "7", color: textcolor,size: textsize),
//     "alphanum_8_${textcolor}_$textsize": () async =>
//         await loadAlphaNum(screen, "8", color: textcolor,size: textsize),
//     "alphanum_9_${textcolor}_$textsize": () async =>
//         await loadAlphaNum(screen, "9", color: textcolor,size: textsize),
//   });
// }

void main() {
  runApp(GameWidget(game: DaPixel()));

  //   windowManager.waitUntilReadyToShow().then((_) async{
  //           await windowManager.setAsFrameless();

  // });
}
