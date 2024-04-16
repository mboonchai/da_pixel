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

  factory SimpleClockApp.basic(Screen screen) {
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

   factory SimpleClockApp.withSeconds(Screen screen) {
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

  factory SimpleClockApp.big(Screen screen) {
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



DaPixelApp createClockShowSeconds(Vector2 screenSize) {
  return SimpleClockApp.withSeconds(createLowResScreen(screenSize));
}

DaPixelApp createClock(Vector2 screenSize) {
  return SimpleClockApp.basic(createLowResScreen(screenSize));
}

DaPixelApp createBigClock(Vector2 screenSize) {
  return SimpleClockApp.big(createHighResScreen(screenSize));
}
