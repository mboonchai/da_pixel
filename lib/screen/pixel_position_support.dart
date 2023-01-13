import 'package:flame/components.dart';

import 'screen.dart';

mixin PixelPositionSupport {
  Vector2 calcPositionFromScreen(Screen screen, Vector2 screenPosition) {
    return screen.getPositionFromScreen(screenPosition);
  }

  Vector2 calcPositionFromScreenWithRotate(
      Screen screen, Vector2 screenPosition) {
    return screen.getPositionFromScreenWithRotate(screenPosition);
  }
}
