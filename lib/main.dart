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

extension Multiplication on Velocity{
  Velocity operator*(double d){
    return Velocity(pixelsPerSecond: pixelsPerSecond*0.5);

  }
}



//Game
class SandGame extends FlameGame with HasCollisionDetection{
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(ScreenHitbox());

    for(int i = 0; i<1;i++){
      add(Sand());
    }
   
  }

  

}

//Sand Element
class Sand extends SpriteComponent with HasGameReference<SandGame>, DragCallbacks, CollisionCallbacks {

  var velocity =  Velocity.zero;
  List<Sand> hitBy = [];

  Sand() : super(
    anchor: Anchor.topLeft
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();

    sprite = await game.loadSprite('sand.png');
    final randomDoubleX = Random().nextDouble() * 500 +100;
    final randomDoubleY = Random().nextDouble() * 500 +100;

    position = Vector2(randomDoubleX, randomDoubleY);
    size = Vector2(50, 50);
    var hitbox = RectangleHitbox.relative(Vector2(1,1), parentSize: size);

    add(hitbox);

    //debugMode = true;

  }

   @override
   void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    velocity = Velocity.zero;

   }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
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

    if (other is Sand && (!hitBy.contains(other) || !other.hitBy.contains(this)) ){
      other.hitBy.add(this);
      hitBy.add(other);

      var velocitySum = velocity + other.velocity;
      velocitySum = velocitySum * 0.5;

      velocity = velocitySum;
      other.velocity = velocitySum;

 
    }

  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other){
    super.onCollision(intersectionPoints, other);

     if (other is ScreenHitbox) {
      final firstPoint = intersectionPoints.first;

      final dx = velocity.pixelsPerSecond.dx * 1  ;
      final dy = velocity.pixelsPerSecond.dy * 1  ;
      const velocityOffset = 0;

        if (firstPoint.x == 0 && firstPoint.y ==0) {
        // Top Left Corner
        velocity = Velocity(pixelsPerSecond: Offset(-dx+velocityOffset, -dy)) ;
      } else if ( firstPoint.x ==game.size.x && firstPoint.y == 0) {
        // Top Right Corner 
        velocity = Velocity(pixelsPerSecond: Offset(-dx, -dy+velocityOffset));
      } else if (firstPoint.x == 0 && firstPoint.y == game.size.y) {
        // Bottom Left Corner
        velocity = Velocity(pixelsPerSecond: Offset(-dx-velocityOffset, -dy));
      } else if (firstPoint.x == game.size.x && firstPoint.y == game.size.y) {
        // Bottom Right Corner 
        velocity = Velocity(pixelsPerSecond: Offset(-dx, -dy));
      }
      else if (firstPoint.x == 0) {
        // Left wall 
        velocity = Velocity(pixelsPerSecond: Offset(-dx, dy)) ;
      } else if (firstPoint.y == 0) {
        // Top wall 
        velocity = Velocity(pixelsPerSecond: Offset(dx, -dy));
      } else if (firstPoint.x == game.size.x) {
        // Right wall
        velocity = Velocity(pixelsPerSecond: Offset(-dx, dy));
      } else if (firstPoint.y == game.size.y) {
        // Bottom wall
        velocity = Velocity(pixelsPerSecond: Offset(dx, -dy));
      }


     

    }


  }

  @override 
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    if(other is Sand && (hitBy.contains(other) || other.hitBy.contains(this))){
      hitBy.remove(other);
      other.hitBy.remove(this);
    }


  }



  


  @override
  void update(double dt){
    super.update(dt);
    
    position.add(velocity.pixelsPerSecond.toVector2().scaled(dt));

    position.clamp(Vector2(0, 0), Vector2(game.size.x - this.size.x , game.size.y - this.size.y));

    try{
    for(PositionComponent other in activeCollisions){
      if(other is Sand){
      final diffOfX = (other.position.x - position.x);
      final diffOfY = (other.position.y - position.y); 

      if(diffOfX.abs() > diffOfY.abs() && diffOfX.sign == -1){
        //this object x > other object x, therefore RIGHT OF OTHER
        position.clamp(Vector2(other.position.x + other.size.x, 0 ), Vector2(game.size.x - this.size.x , game.size.y - this.size.y));
        other.position.clamp(Vector2(0, 0 ), Vector2(this.position.x, game.size.y - this.size.y));
      }
      else if(diffOfX.abs() > diffOfY.abs() && diffOfX.sign == 1){
        //this object x > other object x, therefore LEFT OF OTHER
        position.clamp(Vector2(0, 0 ), Vector2(other.position.x - other.size.x, game.size.y - this.size.y));
        other.position.clamp(Vector2(this.position.x + this.size.x, 0 ), Vector2(game.size.x - other.size.x , game.size.y - other.size.y));

      }
      else if(diffOfX.abs() < diffOfY.abs() && diffOfY.sign == -1){
        //this object y > other object y, therefore BELOW OTHER
        position.clamp(Vector2(0, other.position.y+other.size.y ), Vector2(game.size.x - this.size.x, game.size.y - this.size.y));
        other.position.clamp(Vector2(0, 0 ), Vector2(game.size.x - other.size.x, this.position.y));


      }

      else if(diffOfX.abs() < diffOfY.abs() && diffOfY.sign == 1){
        //this object y < other object y, therefore ABOVE OTHER
        position.clamp(Vector2(0, 0 ), Vector2(game.size.x - this.size.x, other.position.y));
        other.position.clamp(Vector2(0, this.position.y ), Vector2(game.size.x - other.size.x, game.size.y - other.size.y));


      }

      }
    }
    }
    catch(exceptions){}
    
 

    //Gravity
    //  static const gravity = Offset(0, 500);
    //velocity += Velocity(pixelsPerSecond: gravity*dt);



  


  }

  


}
 