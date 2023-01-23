import 'package:da_pixel/app/app.dart';
import 'package:da_pixel/sprites/clock_ampm.dart';
import 'package:da_pixel/sprites/clock_separator.dart';
import 'package:da_pixel/sprites/numbers.dart';
import 'package:flame/extensions.dart';

import 'clock_base.dart';

class ClockInternal extends DaPixelWidget {
  final ClockMode mode;
  final bool blinkSeparator;
  final Color color;

  late final Numbers hour1;
  late final Numbers hour2;
  late final ClockSeparator sep1;
  late final Numbers min1;
  late final Numbers min2;
  ClockSeparator? sep2;
  Numbers? sec1;
  Numbers? sec2;
  ClockAmPm? ampm;

  ClockInternal({
    this.mode = ClockMode.simple,
    this.blinkSeparator = false,
    this.color = const Color(0xffffffff),
    required super.screen,
    required super.screenPosition,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    hour1 = Numbers(screenPosition: Vector2(0, 0), screen: screen);
    hour2 = Numbers(screenPosition: Vector2(4, 0), screen: screen);
    sep1 = ClockSeparator(screenPosition: Vector2(8, 0), screen: screen);
    min1 = Numbers(screenPosition: Vector2(10, 0), screen: screen);
    min2 = Numbers(screenPosition: Vector2(14, 0), screen: screen);

    var size = screen.calcSpriteSize(18, 7);

    await add(hour1);
    await add(hour2);
    await add(sep1);
    await add(min1);
    await add(min2);

    switch (mode) {
      case ClockMode.showSeconds:
        sep2 = ClockSeparator(screenPosition: Vector2(18, 0), screen: screen);
        sec1 = Numbers(screenPosition: Vector2(20, 0), screen: screen);
        sec2 = Numbers(screenPosition: Vector2(24, 0), screen: screen);

        size.x = 28;

        await add(sep2!);
        await add(sec1!);
        await add(sec2!);
        break;

      case ClockMode.showAmPm:
        ampm = ClockAmPm(screenPosition: Vector2(18, 0), screen: screen);
        await add(ampm!);

        size.x = 27;

        break;

      default:
        break;
    }

    width = size.x;
    height = size.y;
  }

  @override
  Future<void> updateApp(int tick) async {
    var now = DateTime.now();

    if (mode == ClockMode.showAmPm) {
      var hourAmPm = now.hour % 12;

      if (now.hour == 12 && now.minute == 0) {
        ampm!.current = AmPmState.am;
        hourAmPm = 12;
      } else if (now.hour == 24 && now.minute == 0) {
        ampm!.current = AmPmState.pm;
        hourAmPm = 12;
      } else {
        ampm!.current = now.hour < 12 ? AmPmState.am : AmPmState.pm;
      }

      var hour1digit = (hourAmPm / 10).floor();

      hour1.current = hour1digit > 0
          ? NumberState.values[hour1digit]
          : NumberState.number_notshow;
      hour2.current = NumberState.values[hourAmPm % 10];
    } else {
      hour1.current = NumberState.values[(now.hour / 10).floor()];
      hour2.current = NumberState.values[now.hour % 10];
    }

    min1.current = NumberState.values[(now.minute / 10).floor()];
    min2.current = NumberState.values[now.minute % 10];

    if (mode == ClockMode.showSeconds) {
      sec1!.current = NumberState.values[(now.second / 10).floor()];
      sec2!.current = NumberState.values[now.second % 10];
    }

    if (blinkSeparator) {
      if (tick % 2 == 0) {
        sep1.current = BlinkState.values[(sep1.current!.index + 1) % 2];

        if (mode == ClockMode.showSeconds) {
          sep2!.current = BlinkState.values[(sep2!.current!.index + 1) % 2];
        }
      }
    }
  }
}
