
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:sand_v1/menu_button.dart';
import 'sand.dart';

class SandGame extends FlameGame with HasCollisionDetection{



  
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(ScreenHitbox());

    for(int i = 0; i<10;i++){
      add(Sand());
    }

    final sprite = await(await images.load('gear.png')).resize(Vector2(50, 50));

    final menuButton = MenuButton(
      button:  Sprite(sprite),
      buttonDown: Sprite(sprite),
      
      position: Vector2(canvasSize.x * 0.95, canvasSize.y * 0.05),
      anchor: Anchor.center,


      onPressed: () {
        overlays.add('Settings');
        reset();
      },

      );

    add(menuButton);

   
  }

  void reset(){
    for ( final component in children){
      if(component is Sand){
        component.velocity = Vector2.zero();
      }
    }
  }

  double getSandAmount(){
    double count = 0;
    for(final component in children){
      if(component is Sand){
        count+=1;
      }
    }
    return count;
  }

   changeAmountOfSand(int newValue) {

     for ( final component in children){
      if(component is Sand){
        remove(component);
      }
    }

    for (var i = 0; i < newValue; i++) {
      add(Sand());
    }
  }

}