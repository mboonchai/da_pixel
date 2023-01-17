import 'package:da_pixel/screen/screen.dart';
import 'package:flame/extensions.dart';

import 'app.dart';
import 'bigclock_internal.dart';
import 'clock_internal.dart';

class BigSimpleClock extends DaPixelApp {
  late final BigClockInternal _clock;

  BigSimpleClock({
    required super.screen,
    required super.screenPosition,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _clock = BigClockInternal(
      screen: screen,
        screenPosition: Vector2(14, 0),
        showSeconds: false,
        blinkSeparator: true,
        color: const Color(0xffffffff));
    await add(_clock);
  }

  @override
  Future<void> updateApp(int tick) async {
    await _clock.updateApp(tick);
  }
}


class ClockWithSeconds extends DaPixelApp {
  late final ClockInternal _clock;

  ClockWithSeconds({
    required super.screen,
    required super.screenPosition,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _clock = ClockInternal(
      screen: screen,
        screenPosition: Vector2(6,1),
        showSeconds: true,
        blinkSeparator: false,
        color: const Color(0xffffffff));
    await add(_clock);
  }

  @override
  Future<void> updateApp(int tick) async {
    await _clock.updateApp(tick);
  }
}

class SimpleClock extends DaPixelApp {
  late final ClockInternal _clock;

  SimpleClock({
    required super.screen,
    required super.screenPosition,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _clock = ClockInternal(
      screen: screen,
        screenPosition: Vector2(11, 1),
        showSeconds: false,
        blinkSeparator: true,
        color: const Color(0xffffffff));
    await add(_clock);
  }

  @override
  Future<void> updateApp(int tick) async {
    await _clock.updateApp(tick);
  }
} 


DaPixelApp createClockShowSeconds(Vector2 screenSize) {
  return ClockWithSeconds(screenPosition: Vector2(0,0),screen: createLowResScreen(screenSize));
}

DaPixelApp createClock(Vector2 screenSize) {
  return SimpleClock(
      screenPosition: Vector2(0,0),
      screen: createLowResScreen(screenSize));
}


DaPixelApp createBigClock(Vector2 screenSize) {
  return BigSimpleClock(
      screenPosition: Vector2(0,0),
      screen: createHighResScreen(screenSize));
}
