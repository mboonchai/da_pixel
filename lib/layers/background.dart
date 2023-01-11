import 'package:da_pixel/pixel.dart';
import 'package:da_pixel/pixels_loader/base.dart';
import 'package:da_pixel/screen/screen.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/layers.dart';

//NOT USE!
//USAGE: 
//      var bgSPriteandSize = await loadbackgroundSprite(screen,const Color(0xff111111));
//      backgroundLayer = BackgroundLayer(bgSPriteandSize?.sprite, position: screen.getPosition(0, 0) ,size: bgSPriteandSize?.size??Vector2(0.0,0.0));
//
class SpriteAndSize {
  final Sprite sprite;
  final Vector2 size;

  SpriteAndSize(this.sprite,this.size);

}

Future<SpriteAndSize?> loadbackgroundSprite(Screen screen, Color color) async{
   PixelData? pixels;
    var result = await loadBackground(screen, color: color);
    if (result.success && result.data != null) {
      pixels = result.data!;
    }

    if (pixels != null) {
      var img = await ImageExtension.fromPixels(
          pixels.data!, pixels.width, pixels.height);
      return SpriteAndSize(Sprite(img),screen
          .calcSpriteSize(pixels.width.toDouble(), pixels.height.toDouble()) ) ;
    } 


    return null;
}


class BackgroundLayer extends PreRenderedLayer {
  final Sprite? sprite;
  final Vector2 position;
  final Vector2 size;

  BackgroundLayer(this.sprite,{required this.position, required this.size});

  @override
  void drawLayer() {

    sprite?.render(
      canvas,
      position: position,
      size: size,
    );
  }
}

