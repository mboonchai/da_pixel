import 'package:da_pixel/app/app.dart';
import 'package:da_pixel/screen/screen.dart';
import 'package:flame/extensions.dart';
import 'bigclock_internal.dart';
import 'clock_base.dart';
import 'clock_internal.dart';


DaPixelWidget _createBigClock(Screen screen) {
  return BigClockInternal(
      screen: screen,
      screenPosition: Vector2(2, 1),
      mode:ClockMode.showAmPm,
      blinkSeparator: true,
      color: const Color(0xffffffff));
}


DaPixelWidget _createClockWithSeconds(Screen screen) {
  return ClockInternal(
      screen: screen,
        screenPosition: Vector2(7,1),
        mode:ClockMode.showSeconds,
        blinkSeparator: false,
        enableTransitionAnimation: true,
        color: const Color(0xffffffff));
}


DaPixelWidget _createSimpleClock(Screen screen) {
  return ClockInternal(
      screen: screen,
        screenPosition: Vector2(5, 1),
        mode:ClockMode.showAmPm,
        blinkSeparator: true,
        color: const Color(0xffffffff));
}



DaPixelApp createClockShowSeconds(Vector2 screenSize) {
  return SimpleClock(
    fnCreateClock: _createClockWithSeconds,
    screenPosition: Vector2(0,0),
    screen: createLowResScreen(screenSize));
}

DaPixelApp createClock(Vector2 screenSize) {
  return SimpleClock(
       fnCreateClock: _createSimpleClock,
      screenPosition: Vector2(0,0),
      screen: createLowResScreen(screenSize));
}


DaPixelApp createBigClock(Vector2 screenSize) {
  return SimpleClock(
       fnCreateClock: _createBigClock,
      screenPosition: Vector2(0,0),
      screen: createHighResScreen(screenSize));
}

