import 'package:da_pixel/app/app.dart';
import 'package:da_pixel/screen/screen.dart';


enum ClockMode {
  simple, // 12:34
  showSeconds, // 12:34:56
  showAmPm, // 12:34 AM
}

class SimpleClock extends DaPixelApp {
  late final DaPixelWidget _clock;
  late final DaPixelWidget Function(Screen) fnCreateClock;

  SimpleClock({
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
