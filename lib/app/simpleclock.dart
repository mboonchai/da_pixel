import 'package:da_pixel/app/app.dart';
import 'package:da_pixel/screen/screen.dart';
import 'package:flame/extensions.dart';

import 'widget/clock/bigclock.dart';
import 'widget/clock/clock.dart';
import 'widget/clock/clockmode.dart';


class SimpleClockApp extends DaPixelApp {
  late final DaPixelWidget _clock;
  late final DaPixelWidget Function(Screen) fnCreateClock;

  SimpleClockApp({
    required this.fnCreateClock,
    required super.screen,
    required super.screenPosition,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _clock = fnCreateClock(screen);
    await add(_clock);
  }

  @override
  Future<void> updateApp(int tick) async {
    await _clock.updateApp(tick);
  }
}



DaPixelApp createClockShowSeconds(Vector2 screenSize) {
  return SimpleClockApp(
      fnCreateClock: (Screen screen) => Clock(
          screen: screen,
          screenPosition: Vector2(7, 1),
          mode: ClockMode.showSeconds,
          blinkSeparator: false,
          enableTransitionAnimation: true,
          color: const Color(0xffffffff)),
      screenPosition: Vector2(0, 0),
      screen: createLowResScreen(screenSize));
}

DaPixelApp createClock(Vector2 screenSize) {
  return SimpleClockApp(
      fnCreateClock: (Screen screen) => Clock(
          screen: screen,
          screenPosition: Vector2(5, 1),
          mode: ClockMode.showAmPm,
          blinkSeparator: true,
          color: const Color(0xffffffff)),
      screenPosition: Vector2(0, 0),
      screen: createLowResScreen(screenSize));
}

DaPixelApp createBigClock(Vector2 screenSize) {
  return SimpleClockApp(
      fnCreateClock: (Screen screen) => BigClock(
          screen: screen,
          screenPosition: Vector2(2, 1),
          mode: ClockMode.showAmPm,
          blinkSeparator: true,
          color: const Color(0xffffffff)),
      screenPosition: Vector2(0, 0),
      screen: createHighResScreen(screenSize));
}
