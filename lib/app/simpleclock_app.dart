import 'package:da_pixel/app/app.dart';
import 'package:da_pixel/app/placer.dart';
import 'package:da_pixel/screen/screen.dart';
import 'package:flame/extensions.dart';

import 'widget/clock/bigclock.dart';
import 'widget/clock/clock.dart';
import 'widget/clock/clockmode.dart';


class SimpleClockApp extends DaPixelApp {

  SimpleClockApp._({
    required super.screen,
    required super.widgets,
    required super.placer,
  });

  factory SimpleClockApp.basic(Vector2 screenSize) {

    final screen = Screen.lowRes(screenSize);

    return SimpleClockApp._(
        screen: screen,
        placer: CenterPlacer(),
        widgets: [
          Clock(
          screen: screen,
          mode: ClockMode.simple,
          blinkSeparator: true,
          enableTransitionAnimation: true,
          color: const Color(0xffffffff)),
        ]);
  }

   factory SimpleClockApp.withSeconds(Vector2 screenSize) {

    final screen = Screen.lowRes(screenSize);

    return SimpleClockApp._(
        screen: screen,
        placer: CenterPlacer(),
        widgets: [
          Clock(
          screen: screen,
          mode:ClockMode.showSeconds,
          blinkSeparator: false,
          enableTransitionAnimation: true,
          color: const Color(0xffffffff)),
        ]);
  }

  factory SimpleClockApp.big(Vector2 screenSize) {

    final screen = Screen.highRes(screenSize);

    return SimpleClockApp._(
        screen: screen,
        placer: CenterPlacer(),
        widgets: [
          BigClock(
          screen: screen,
          mode: ClockMode.simple,
          blinkSeparator: true,
          color: const Color(0xffffffff)),
        ]);
  }


  @override
  Future<void> onLoad() async {
    return await super.onLoad();
  }

  @override
  Future<void> updateApp(int tick) async {
    return await super.updateApp(tick);
  }
}

