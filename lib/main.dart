import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'dart:math';




void main() {
  runApp(GameWidget(game: SandGame()));
}

//Game
class SandGame extends FlameGame with HasCollisionDetection{
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(ScreenHitbox());
    add(Side());

    for(int i = 0; i<=1;i++){
      add(Sand());
    }
   
  }

  

}

//WIP
class Side extends PositionComponent with HasCollisionDetection{
  Side() : super(
    anchor: Anchor.topLeft);

    @override
    Future<void> onLoad() async {
    super.onLoad();

    var randomDouble = Random().nextDouble() * 500 +100;

    position = Vector2(randomDouble, randomDouble);
    size = Vector2(0, 0);
    add(RectangleHitbox(isSolid: true, position: Vector2(size.x, 1000), size: Vector2(1000, 150)));
    }

      

}

//Sand Element
class Sand extends SpriteComponent with HasGameReference<SandGame>, DragCallbacks, CollisionCallbacks {

  var velocity =  Velocity.zero;

  Sand() : super(
    anchor: Anchor.center
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();

    sprite = await game.loadSprite('sand.png');

    var randomDouble = Random().nextDouble() * 500 +100;

    position = Vector2(randomDouble, randomDouble);
    size = Vector2(100, 100);
    add(CircleHitbox(isSolid: true));

  }

   @override
   void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    velocity = Velocity.zero;

   }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    //velocity += Velocity(pixelsPerSecond: event.localDelta.toOffset()*10);
    position += event.localDelta;
    velocity = Velocity.zero;

  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    velocity += Velocity(pixelsPerSecond: event.velocity.toOffset());
    
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other){
    super.onCollisionStart(intersectionPoints, other);

    if (other is Sand){
      other.velocity += velocity;
      velocity = Velocity.zero;
    }

    else if (other is ScreenHitbox || other is Side) {
      final firstPoint = intersectionPoints.first;

      final dx = velocity.pixelsPerSecond.dx * 0.5 ;
      final dy = velocity.pixelsPerSecond.dy * 0.5 ;

      if (firstPoint.x == 0) {
        // Left wall (or one of the leftmost corners)
        velocity = Velocity(pixelsPerSecond: Offset(-dx, dy)) ;
      } else if (firstPoint.y == 0) {
        // Top wall (or one of the upper corners)
        velocity = Velocity(pixelsPerSecond: Offset(dx, -dy));
      } else if (firstPoint.x == game.size.x) {
        // Right wall (or one of the rightmost corners)
        velocity = Velocity(pixelsPerSecond: Offset(-dx, dy));
      } else if (firstPoint.y == game.size.y) {
        // Bottom wall (or one of the bottom corners)
        velocity = Velocity(pixelsPerSecond: Offset(dx, -dy));
      }
    }
  }

  
  static const gravity = Velocity(pixelsPerSecond: Offset(0, 20));

  @override
  void update(double dt){
    super.update(dt);
    position.add(velocity.pixelsPerSecond.toVector2().scaled(dt));

    //Drag
    const stopOffset = 0.001;
    var x = velocity.pixelsPerSecond.dx + stopOffset;
    var y = velocity.pixelsPerSecond.dy + stopOffset;

    x = x*x * x.sign * -1 * 0.0001;
    y = y*y * y.sign * -1 * 0.0001;


    var dv = Velocity(pixelsPerSecond: Offset(x,y));

    if((x.abs() <= 0.005 ) && (y.abs() <= 0.005)) {
      velocity = Velocity.zero;
    }
    else{
      velocity +=  dv;
    }
  
    //Gravity
    velocity += gravity;


    //Return to playing field

       if (position.x <= 0) {
        // Left wall (or one of the leftmost corners)
        velocity += Velocity(pixelsPerSecond: Offset(150, 0)) ;
      } else if (position.y <= 0) {
        // Top wall (or one of the upper corners)
        velocity += Velocity(pixelsPerSecond: Offset(0, -150));
      } else if (position.x >= game.size.x) {
        // Right wall (or one of the rightmost corners)
        velocity += Velocity(pixelsPerSecond: Offset(-150, 0));
      } else if (position.y >= game.size.y) {
        // Bottom wall (or one of the bottom corners)
        velocity += Velocity(pixelsPerSecond: Offset(0, -150));
      }
      



  }


}
 