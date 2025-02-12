import 'package:da_pixel/app/app.dart';
import 'package:da_pixel/sprites/char.dart';
import 'package:da_pixel/sprites/numbers.dart';
import 'package:flame/game.dart';

class DayOfWeekWidget extends DaPixelWidget {
  int _curDay = 0;
  late final Numbers _date1;
  late final Numbers _date2;
  late final Numbers _dateOneDigit;
  late final Char _dayOfWeek1;
  late final Char _dayOfWeek2;

  DayOfWeekWidget({
    required super.screen,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _date1 = Numbers(screenPosition: Vector2(0, 0), screen: screen);
    _date2 = Numbers(screenPosition: Vector2(4, 0), screen: screen);
    _dateOneDigit = Numbers(screenPosition: Vector2(2, 0), screen: screen);

    _dayOfWeek1 =
        Char(characterCode: "T", screenPosition: Vector2(0, 8), screen: screen);
    _dayOfWeek2 =
        Char(characterCode: "H", screenPosition: Vector2(4, 8), screen: screen);

    await add(_date1);
    await add(_date2);
    await add(_dateOneDigit);
    await add(_dayOfWeek1);
    await add(_dayOfWeek2);
  }

  @override
  Vector2 screenSize() {
    return Vector2(8, 16);
  }

  @override
  Future<void> updateApp(int tick) async{
    if (tick != 1) {
      return;
    }

    var day = DateTime.now().day;
    if (_curDay == day) {
      return;
    }
    _curDay = day;

    if (_curDay < 10) {
      _date1.current = NumberState.number_notshow;
      _date2.current = NumberState.number_notshow;
      _dateOneDigit.current = NumberState.values[_curDay];
    } else {
      _date1.current = NumberState.values[(_curDay / 10).floor()];
      _date2.current = NumberState.values[_curDay % 10];
      _dateOneDigit.current = NumberState.number_notshow;
    }

    //var dayOfWeek = DateTime.now().weekday;

  }
}
