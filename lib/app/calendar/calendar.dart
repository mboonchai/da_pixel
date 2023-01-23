import 'package:da_pixel/app/app.dart';
import 'package:da_pixel/app/clock/bigclock_internal.dart';
import 'package:da_pixel/app/clock/clock_base.dart';
import 'package:da_pixel/screen/screen.dart';
import 'package:flame/extensions.dart';

import 'calendar_icon.dart';

class SimpleCalendar extends DaPixelApp {
  late final DaPixelWidget _icon;
  late final DaPixelWidget _clock;

  SimpleCalendar({required super.screenPosition, required super.screen});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _icon = CalendarIconWidget(
      screen: screen,
      screenPosition: Vector2(2,2),
    ); 
    
    _clock = BigClockInternal(
      screen: screen,
        screenPosition: Vector2(22, 1),
        mode: ClockMode.simple,
        blinkSeparator: true,
        color: const Color(0xffffffff));

    await add(_icon);
    await add(_clock);
  }

  @override
  Future<void> updateApp(int tick) async {
    await _icon.updateApp(tick);
    await _clock.updateApp(tick);
  }


}

DaPixelApp createSimpleCalendar(Vector2 screenSize) {
  return SimpleCalendar(
    screenPosition: Vector2(0, 0),
    screen: createHighResScreen(screenSize),
  );
}