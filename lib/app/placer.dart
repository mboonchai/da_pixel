import 'package:flame/components.dart';

import 'app.dart';

//[1][2][3]...
class BasicHorizontalPlacer implements WidgetPlacer {
  int _curPosX = 0;
  int padding;

  BasicHorizontalPlacer({this.padding = 2});

  @override
  void setPosition(int index, Vector2 screenSize, DaPixelWidget widget) {
    var pos = Vector2.zero();
    var size = widget.screenSize();

    pos.y = ((screenSize.y - size.y) / 2).floorToDouble();
    pos.x = (_curPosX + padding).floorToDouble();

    _curPosX = (_curPosX + size.x + padding).floor();

    widget.screenPosition = pos;
  }
}

class CenterPlacer implements WidgetPlacer {
  int _curPosX = 0;
  int padding;

  CenterPlacer({this.padding = 1});

  @override
  void setPosition(int index, Vector2 screenSize, DaPixelWidget widget) {
    var pos = Vector2.zero();
    var size = widget.screenSize();

    pos.y = ((screenSize.y - size.y) / 2).floorToDouble();
    pos.x = _curPosX + padding + ((screenSize.x - _curPosX - padding - size.x) / 2).floorToDouble();

    _curPosX = screenSize.x.floor();

    widget.screenPosition = pos;
  }
}

//[1][   2    ]
class IconWithMainPlacer implements WidgetPlacer {
  int _curPosX = 0;
  int padding;
  int index = 0;

  IconWithMainPlacer({this.padding = 2});

  @override
  void setPosition(int index, Vector2 screenSize, DaPixelWidget widget) {
    var pos = Vector2.zero();
    var size = widget.screenSize();

    if (index != 1) {
      pos.y = ((screenSize.y - size.y) / 2).floorToDouble();
      pos.x = (_curPosX + padding).floorToDouble();
      _curPosX = (_curPosX + size.x + padding).floor();
      ++index;
    } else {
      pos.y = ((screenSize.y - size.y) / 2).floorToDouble();
      pos.x =
          padding + _curPosX + ((screenSize.x - _curPosX - padding- size.x) / 2).floorToDouble();
      _curPosX = screenSize.x.floor();
      ++index;
    }

    widget.screenPosition = pos;
  }
}

class NullPlacer implements WidgetPlacer {
  @override
  void setPosition(int index, Vector2 screenSize, DaPixelWidget widget) {
    
  }
}

NullPlacer nullPlacer = NullPlacer();