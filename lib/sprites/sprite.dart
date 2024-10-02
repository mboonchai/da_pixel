import 'dart:developer';
import 'dart:ui';

import 'package:da_pixel/config.dart';
import 'package:da_pixel/pixels/pixel.dart';
import 'package:da_pixel/screen/pixel_position_support.dart';
import 'package:da_pixel/screen/screen.dart';
import 'package:da_pixel/sprites_cache/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:meta/meta.dart';

abstract class DaPixelSpriteComponent extends SpriteComponent
    with PixelPositionSupport {
  final Vector2 screenPosition;
  final Screen screen;

  DaPixelSpriteComponent(
      {required this.screenPosition, required this.screen, super.angle});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    position = calcPositionFromScreen(screen, screenPosition);

    //print("position $position");
    //sprite not handle the rotate...
    // if(Config.rotateScreen) {
    //     angle = pi/2;

    // }
  }
}

/// [DaPixelSpriteGroupComponent] is a [SpriteGroupComponent] with custom transition animation support
abstract class DaPixelSpriteGroupComponent<T> extends PositionComponent
    with PixelPositionSupport, HasPaint
    implements SizeProvider {
  T? current;
  T? _next;
  double transitionStep = 7;
  final double _transitionDuration = Config.transitionDuration;
  DateTime startTransitionDt = DateTime.fromMillisecondsSinceEpoch(0);
  int _stepMilliseconds = 0;
  bool _drawAnimation = false;
  int _curStep = 0;
  int _nextStep = 0;

  Map<T, Sprite>? sprites;

  final Vector2 screenPosition;
  final Screen screen;

  DaPixelSpriteGroupComponent({
    required this.screenPosition,
    required this.screen,
    this.sprites,
    this.current,
    this.transitionStep = 7, //7 for small -- 14 for large
    Paint? paint,
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.nativeAngle,
    super.anchor,
    super.children,
    super.priority,
  }) {
    if (paint != null) {
      this.paint = paint;
    }

    _stepMilliseconds = ((_transitionDuration * 1000) / transitionStep).floor();
  }

  Sprite? get sprite => sprites?[current];

  @override
  @mustCallSuper
  void onMount() {
    assert(
      sprites != null,
      'You have to set the sprites in either the constructor or in onLoad',
    );
    assert(
      current != null,
      'You have to set current in either the constructor or in onLoad',
    );
  }

  @mustCallSuper
  @override
  void render(Canvas canvas) {
    if (_drawAnimation) {
      canvas.clipRect(Rect.fromLTWH(0, 0, width, height));

      sprite?.render(
        canvas,
        position:
            Vector2(0, -(screen.pixelSize + screen.pixelGap) * (_curStep)),
        size: size,
        overridePaint: paint,
      );

      sprites?[_next]?.render(
        canvas,
        position: Vector2(
            0,
            (screen.pixelSize + screen.pixelGap) *
                (transitionStep - (_curStep))),
        size: size,
        overridePaint: paint,
      );

      return;
    }
    sprite?.render(
      canvas,
      size: size,
      overridePaint: paint,
    );
  }

  void setNext(T next) {
    if (_next == next) {
      return;
    }

    _next = next;
    if (_next != current) {
      //begin animation...
      startTransitionDt = DateTime.now();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    var now = DateTime.now();
    if (startTransitionDt
        .add(Duration(milliseconds: (_transitionDuration * 1000).floor()))
        .isAfter(now)) {
      _nextStep = ((now.millisecondsSinceEpoch -
                  startTransitionDt.millisecondsSinceEpoch) /
              _stepMilliseconds)
          .floor();

      if (_nextStep != _curStep) {
        _curStep = _nextStep;
       _drawAnimation = true;
      } else {
        _drawAnimation = false;
      }

      //TODO: Findout why number suddenly change without animation
      //log("_curStep $_curStep");

      _drawAnimation = true;
    } else {
      _drawAnimation = false;
      _next = current;
    }
  }

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    position = calcPositionFromScreen(screen, screenPosition);
  }

  Future<Image> fromPixelData(PixelData data) async {
    return ImageExtension.fromPixels(data.data!, data.width, data.height);
  }

  Future<PixelLoadResult> Function() loadAlphaNumFromCache(
      String char, Color color,
      {CharSize size = CharSize.small}) {
    return () async => loadAndCache("alphanum_${char}_${color}_$size",
        () async => await loadAlphaNum(screen, char, color: color, size: size));
  }

  Future<PixelLoadResult> Function() loadWordFromCache(String word, Color color,
      {CharSize size = CharSize.small}) {
    return () async => loadAndCache("word_${word}_${color}_$size",
        () async => await loadWords(screen, word, color: color, size: size));
  }
}
