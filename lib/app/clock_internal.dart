import 'package:da_pixel/screen/pixel_position_support.dart';
import 'package:da_pixel/screen/screen.dart';
import 'package:da_pixel/sprites/clock_separator.dart';
import 'package:da_pixel/sprites/numbers.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';


class ClockInternal extends PositionComponent
    with PixelPositionSupport {
  final Vector2 screenPosition;
  final Screen screen;

  final bool showSeconds;
  final bool blinkSeparator;
  final Color color;

  late final Numbers hour1;
  late final Numbers hour2;
  late final ClockSeparator sep1;
  late final Numbers min1;
  late final Numbers min2;
  late final ClockSeparator? sep2;
  late final Numbers? sec1;
  late final Numbers? sec2;

  ClockInternal({
    this.showSeconds = true,
    this.blinkSeparator = false,
    this.color = const Color(0xffffffff),
    required this.screen,
    required this.screenPosition,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    position = calcPositionFromScreen(screen, screenPosition);

    hour1 = Numbers(screenPosition: Vector2(0, 0),screen:screen);
    hour2 = Numbers(screenPosition: Vector2(4, 0),screen:screen);
    sep1 = ClockSeparator(screenPosition: Vector2(8, 0),screen:screen);
    min1 = Numbers(screenPosition: Vector2(10, 0),screen:screen);
    min2 = Numbers(screenPosition: Vector2(14, 0),screen:screen);

    if (showSeconds) {
      sep2 = ClockSeparator(screenPosition: Vector2(18, 0),screen:screen);
      sec1 = Numbers(screenPosition: Vector2(20, 0),screen:screen);
      sec2 = Numbers(screenPosition: Vector2(24, 0),screen:screen);

      var size = screen.calcSpriteSize(28, 7);
      width = size.x;
      height = size.y;
    } else {
      sep2 = null;
      sec1 = null;
      sec2 = null;

      var size = screen.calcSpriteSize(18, 7);
      width = size.x;
      height = size.y;
    }

    await add(hour1);
    await add(hour2);
    await add(sep1);
    await add(min1);
    await add(min2);

    if (showSeconds) {
      await add(sep2!);
      await add(sec1!);
      await add(sec2!);
    }
  }

  Future<void> updateApp(int tick) async {
    var now = DateTime.now();

    hour1.current = NumberState.values[(now.hour / 10).floor()];
    hour2.current = NumberState.values[now.hour % 10];

    min1.current = NumberState.values[(now.minute / 10).floor()];
    min2.current = NumberState.values[now.minute % 10];

    if (showSeconds) {
      sec1!.current = NumberState.values[(now.second / 10).floor()];
      sec2!.current = NumberState.values[now.second % 10];
    }

    if (blinkSeparator) {
      if (tick % 2 == 0) {
        sep1.current = BlinkState.values[(sep1.current!.index + 1) % 2];

        if (showSeconds) {
          sep2!.current = BlinkState.values[(sep2!.current!.index + 1) % 2];
        }
      }
    }
  }
}
