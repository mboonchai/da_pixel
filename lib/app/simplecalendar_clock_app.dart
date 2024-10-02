import 'package:da_pixel/app/app.dart';
import 'package:da_pixel/app/placer.dart';
import 'package:da_pixel/screen/screen.dart';
import 'package:flame/extensions.dart';

import 'widget/calendar/bigcalendar_icon.dart';
import 'widget/calendar/calendar_icon.dart';
import 'widget/clock/bigclock.dart';
import 'widget/clock/clock.dart';
import 'widget/clock/clockmode.dart';


class SimpleCalendarClockApp extends DaPixelApp {

  SimpleCalendarClockApp.
  _({required super.screen, required super.widgets,super.placer});

  factory SimpleCalendarClockApp.big(Vector2 screenSize) {

    final screen = Screen.highRes(screenSize);

    return SimpleCalendarClockApp._(
        screen: screen,
        placer: IconWithMainPlacer(padding: 2),
        widgets: [
          BigCalendarIconWidget(
            screen: screen,
          ),
          BigClock(
              screen: screen,
              mode: ClockMode.simple,
              blinkSeparator: true,
              enableTransitionAnimation: false,
              color: const Color(0xffffffff)),
        ]
        );
  }

  factory SimpleCalendarClockApp.normal(Vector2 screenSize) {

    final screen = Screen.lowRes(screenSize);

    return SimpleCalendarClockApp._(
        screen: screen,
        placer: IconWithMainPlacer(padding: 2),
        widgets: [
          CalendarIconWidget(
            screen: screen,
          ),
          Clock(
              screen: screen,
              mode: ClockMode.simple,
              blinkSeparator: true,
              enableTransitionAnimation: true,
              color: const Color(0xffffffff)),
        ]
        );
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
