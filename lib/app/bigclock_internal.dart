import 'package:da_pixel/pixel.dart';
import 'package:da_pixel/screen/pixel_position_support.dart';
import 'package:da_pixel/screen/screen.dart';
import 'package:da_pixel/sprites/clock_separator.dart';
import 'package:da_pixel/sprites/numbers.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';


class BigClockInternal extends PositionComponent
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

  BigClockInternal({
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

    hour1 = Numbers(screenPosition: Vector2(0, 0),screen:screen, textSize: CharSize.large);
    hour2 = Numbers(screenPosition: Vector2(8, 0),screen:screen, textSize: CharSize.large);
    sep1 = ClockSeparator(screenPosition: Vector2(16, 0),screen:screen, textSize: CharSize.large);
    min1 = Numbers(screenPosition: Vector2(20, 0),screen:screen, textSize: CharSize.large);
    min2 = Numbers(screenPosition: Vector2(28, 0),screen:screen, textSize: CharSize.large);

    if (showSeconds) {
      sep2 = ClockSeparator(screenPosition: Vector2(36, 0),screen:screen, textSize: CharSize.large);
      sec1 = Numbers(screenPosition: Vector2(40, 0),screen:screen, textSize: CharSize.large);
      sec2 = Numbers(screenPosition: Vector2(48, 0),screen:screen, textSize: CharSize.large);

      var size = screen.calcSpriteSize(56, 14);
      width = size.x;
      height = size.y;
    } else {
      sep2 = null;
      sec1 = null;
      sec2 = null;

      var size = screen.calcSpriteSize(36, 14);
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
