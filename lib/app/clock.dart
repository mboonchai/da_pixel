import 'package:flame/extensions.dart';

import 'app.dart';
import 'clock_internal.dart';

class Clock extends DaPixelApp {
  final bool showSeconds;
  final bool blinkSeparator;
  final Color color;

  late final ClockInternal _clock;

  Clock({
    this.showSeconds = true,
    this.blinkSeparator = false,
    this.color = const Color(0xffffffff),
    required super.screenPosition,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _clock = ClockInternal(
        screenPosition: Vector2(0, 0),
        showSeconds: showSeconds,
        blinkSeparator: blinkSeparator,
        color: color);

    await add(_clock);
  }

  @override
  Future<void> updateApp(int tick) async {
    await _clock.updateApp(tick);
  }
}

DaPixelApp createClockShowSeconds() {
  return Clock(screenPosition: Vector2(6, 1));
}

DaPixelApp createClock() {
  return Clock(
      screenPosition: Vector2(11, 1), showSeconds: false, blinkSeparator: true);
}
