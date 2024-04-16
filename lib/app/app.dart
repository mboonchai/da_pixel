import 'dart:async';
import 'package:da_pixel/screen/pixel_position_support.dart';
import 'package:da_pixel/screen/screen.dart';
import 'package:da_pixel/sprites/background.dart';
import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

abstract class DaPixelApp extends PositionComponent with PixelPositionSupport {
  final Screen screen;
  final double period; //period that will actually updated
  late final WidgetPlacer? placer;
  late final List<DaPixelWidget> widgets;

  double _curDT = -0.01; //last update pass
  int _curTick = 0; //internal usage --> count period circle 0,1,2,3

  DaPixelApp(
      {required this.screen,
      required this.widgets,
      this.placer,
      this.period = 0.5});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    position = calcPositionFromScreenWithRotate(screen, Vector2(0, 0));

    await add(Background(screen: screen, position: Vector2(0, 0)));

    var screenSize = Vector2(screen.width, screen.height);
    for (var i = 0; i < widgets.length; i++) {
      var widget = widgets[i];

      if (placer != null) {
        placer!.setPosition(i, screenSize, widget);
      }

      await add(widget);
    }
  }

  @override
  @mustCallSuper
  void update(double dt) {
    super.update(dt);

    if (_curDT < 0) {
      _curDT = 0;
      _curTick = (_curTick + 1) % 8;
      updateApp(_curTick);
      return;
    }

    _curDT += dt;
    if (_curDT > period) {
      _curDT = 0;
      _curTick = (_curTick + 1) % 8;
      updateApp(_curTick);
    }
  }

  Future<void> updateApp(int tick) async {
    for (var widget in widgets) {
      await widget.updateApp(tick);
    }
  }

  Future<void> precache(Screen screen) async {
    return Future.value();
  }
}

abstract class Updatable {
  Future<void> updateApp(int tick);
}

abstract class DaPixelWidget extends PositionComponent
    with PixelPositionSupport
    implements Updatable {
  Vector2 screenPosition = Vector2.zero();
  final Screen screen;

  DaPixelWidget({required this.screen});
  DaPixelWidget.withScreenPosition(
      {required this.screen, required this.screenPosition});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    position = calcPositionFromScreen(screen, screenPosition);

    var size = screen.calcSpriteSizeFromVector2(screenSize());
    width = size.x;
    height = size.y;
  }

  Vector2 screenSize();

  Future<void> precache(Screen screen) async {
    return Future.value();
  }
}

abstract class WidgetPlacer {
  void setPosition(int index, Vector2 screenSize, DaPixelWidget widget);
}
