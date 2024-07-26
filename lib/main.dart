import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'sand.dart';


void main() {
  runApp(GameWidget(game: SandGame()));
}



//Game
class SandGame extends FlameGame with HasCollisionDetection{
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(ScreenHitbox());

    for(int i = 0; i<10;i++){
      add(Sand());
    }
   
  }

  

}

class Background extends RectangleComponent{

   @override
  Future<void> onLoad() async {
    await super.onLoad();

  }



}