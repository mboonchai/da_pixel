import 'package:da_pixel/config.dart';
import 'package:da_pixel/pixels/pixel.dart';
import 'package:da_pixel/sprites/clock_ampm.dart';
import 'package:da_pixel/sprites/clock_separator.dart';
import 'package:da_pixel/sprites/numbers.dart';
import 'package:flame/extensions.dart';
import 'package:da_pixel/app/app.dart';
import 'clockmode.dart';

class BigClock extends DaPixelWidget {
  final ClockMode mode;
  final bool blinkSeparator;
  final Color color;
  
  final bool enableTransitionAnimation;
  final double _transitionDuration =  Config.transitionDuration;

  late final Numbers hour1;
  late final Numbers hour2;
  late final ClockSeparator sep1;
  late final Numbers min1;
  late final Numbers min2;
  late ClockSeparator? sep2;
  late Numbers? sec1;
  late Numbers? sec2;
  ClockAmPm? ampm;

  BigClock({
    this.mode = ClockMode.simple,
    this.blinkSeparator = false,
    this.color = const Color(0xffffffff),
    this.enableTransitionAnimation = false,
    required super.screen,
  });

  @override
  Vector2 screenSize() {
    if(mode==ClockMode.showSeconds) {
      return Vector2(56, 14);
    } else {
      return Vector2(36, 14);
    }
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    hour1 = Numbers(
        screenPosition: Vector2(0, 0),
        screen: screen,
        textSize: CharSize.large,color: color,
        transitionStep: 14);
    hour2 = Numbers(
        screenPosition: Vector2(8, 0),
        screen: screen,
        textSize: CharSize.large,color: color,
        transitionStep: 14);
    sep1 = ClockSeparator(
        screenPosition: Vector2(16, 0),
        screen: screen,
        textSize: CharSize.large,color: color);
    min1 = Numbers(
        screenPosition: Vector2(20, 0),
        screen: screen,
        textSize: CharSize.large,color: color,
        transitionStep: 14);
    min2 = Numbers(
        screenPosition: Vector2(28, 0),
        screen: screen,
        textSize: CharSize.large,color: color,
        transitionStep: 14);

    await add(hour1);
    await add(hour2);
    await add(sep1);
    await add(min1);
    await add(min2);

    switch (mode) {
      case ClockMode.showSeconds:
        sep2 = ClockSeparator(
            screenPosition: Vector2(36, 0),
            screen: screen,
            textSize: CharSize.large,color: color);
        sec1 = Numbers(
            screenPosition: Vector2(40, 0),
            screen: screen,
            textSize: CharSize.large,color: color,
            transitionStep: 14);
        sec2 = Numbers(
            screenPosition: Vector2(48, 0),
            screen: screen,
            textSize: CharSize.large,color: color,
            transitionStep: 14);

        await add(sep2!);
        await add(sec1!);
        await add(sec2!);
        break;
      case ClockMode.showAmPm:
        ampm = ClockAmPm(screenPosition: Vector2(36, 0), screen: screen,textSize:CharSize.large ,color: color);
        await add(ampm!);


        break;

      default:
        break;
    }

  }

  @override
  Future<void> updateApp(int tick) async {
    var now = DateTime.now();
        var next =
        now.add(Duration(milliseconds: (_transitionDuration * 1000).floor()));

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

 //set next
    if (enableTransitionAnimation) {
      if (mode == ClockMode.showAmPm) {
        var hourAmPm = next.hour % 12;

        if (next.hour == 12 && next.minute == 0) {
          ampm!.setNext(AmPmState.am);
          hourAmPm = 12;
        } else if (next.hour == 24 && next.minute == 0) {
          ampm!.setNext(AmPmState.pm);
          hourAmPm = 12;
        } else {
          ampm!.setNext(next.hour < 12 ? AmPmState.am : AmPmState.pm);
        }

        var hour1digit = (hourAmPm / 10).floor();

        hour1.setNext(hour1digit > 0
            ? NumberState.values[hour1digit]
            : NumberState.number_notshow);
        hour2.setNext(NumberState.values[hourAmPm % 10]);
      } else {
        hour1.setNext(NumberState.values[(next.hour / 10).floor()]);
        hour2.setNext(NumberState.values[next.hour % 10]);
      }

      min1.setNext(NumberState.values[(next.minute / 10).floor()]);
      min2.setNext(NumberState.values[next.minute % 10]);

      if (mode == ClockMode.showSeconds) {
        sec1!.setNext(NumberState.values[(next.second / 10).floor()]);
        sec2!.setNext(NumberState.values[next.second % 10]);
      }
    }

  }
}
