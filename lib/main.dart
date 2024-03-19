import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';



void main() {
  runApp(GameWidget(game: SandGame()));
}

//Game
class SandGame extends FlameGame with HasCollisionDetection{
  late Sand sand;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sand = Sand();

    add(sand);

  }

  @override
  void update(double dt){
    super.update(dt);

  }
}

//Sand Element
class Sand extends SpriteComponent with HasGameReference<SandGame>, DragCallbacks {

  //var velocity = const Velocity(pixelsPerSecond: Offset(0, 0));

  Sand() : super(
    size: Vector2(10, 10),
    anchor: Anchor.center
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();

    sprite = await game.loadSprite('sand.png');
    position = Vector2(100, 100);
    size = Vector2(100, 100);
    add(CircleHitbox());

  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    position += event.localDelta;
  }



  }
 