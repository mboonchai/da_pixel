import 'package:da_pixel/app/app.dart';
import 'package:da_pixel/sprites/common_sprite.dart';
import 'package:da_pixel/sprites/numbers.dart';
import 'package:da_pixel/sprites/sprite.dart';
import 'package:flame/extensions.dart';

class BigCalendarIconWidget extends DaPixelWidget {
  int _curDay = 0;
  late final DaPixelSpriteComponent _frame;
  late final Numbers date1;
  late final Numbers date2;
  late final Numbers dateOneDigit;

  BigCalendarIconWidget({
    required super.screen,
  });

  @override
  Vector2 screenSize() {
    return Vector2(11, 12);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _frame = CommonSpriteComponent(
      screen: screen,
      screenPosition: Vector2(0, 0),
      assetName: "calendar_frame_big.png",
    );

    date1 = Numbers(
      color: const Color(0xFF000000),
      screen: screen,
      screenPosition: Vector2(2, 4),
    );

    date2 = Numbers(
      color: const Color(0xFF000000),
      screen: screen,
      screenPosition: Vector2(6, 4),
    );

    dateOneDigit = Numbers(
      color: const Color(0xFF000000),
      screen: screen,
      screenPosition: Vector2(4, 4),
    );

    await add(_frame);
    await add(date1);
    await add(date2);
    await add(dateOneDigit);
    date1.current = NumberState.number_notshow;
    date2.current = NumberState.number_notshow;
    dateOneDigit.current = NumberState.number_notshow;
  }

  @override
  Future<void> updateApp(int tick) async {
    if (tick != 1) {
      return;
    }

    var day = DateTime.now().day;
    if (_curDay == day) {
      return;
    }

    _curDay = day;

    if (_curDay < 10) {
      date1.current = NumberState.number_notshow;
      date2.current = NumberState.number_notshow;
      dateOneDigit.current = NumberState.values[_curDay];
    } else {
      date1.current = NumberState.values[(_curDay / 10).floor()];
      date2.current = NumberState.values[_curDay % 10];
      dateOneDigit.current = NumberState.number_notshow;
    }

    
  }
}
