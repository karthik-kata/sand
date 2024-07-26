
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:sand_v1/main.dart';
import 'dart:math';


//Sand Element
class Sand extends SpriteComponent with HasGameReference<SandGame>, DragCallbacks, CollisionCallbacks {

  var velocity =  Vector2.zero();
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
    velocity = Vector2.zero();

   }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    position += event.localDelta;
    velocity = Vector2.zero();

  }

  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    velocity += event.velocity;
    
  }


  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other){
    super.onCollisionStart(intersectionPoints, other);
    

  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other){
    super.onCollision(intersectionPoints, other);


    if (other is Sand && (!hitBy.contains(other) || !other.hitBy.contains(this)) ){
      other.hitBy.add(this);
      hitBy.add(other);

      var velocitySum = (velocity + other.velocity).scaled(0.5);

      velocity = velocitySum;
      other.velocity = velocitySum;

 
    }


     if (other is ScreenHitbox) {
      final firstPoint = intersectionPoints.first;

      final dx = velocity.x;
      final dy = velocity.y;

        if (firstPoint.x == 0 && firstPoint.y ==0) {
        // Top Left Corner
        velocity = Vector2(-dx, -dy);
      } else if ( firstPoint.x ==game.size.x && firstPoint.y == 0) {
        // Top Right Corner 
        velocity = Vector2(-dx, -dy);
      } else if (firstPoint.x == 0 && firstPoint.y == game.size.y) {
        // Bottom Left Corner
        velocity = Vector2(-dx, -dy);
      } else if (firstPoint.x == game.size.x && firstPoint.y == game.size.y) {
        // Bottom Right Corner 
        velocity = Vector2(-dx, -dy);
      }
      else if (firstPoint.x == 0) {
        // Left wall 
        velocity = Vector2(-dx, dy);
      } else if (firstPoint.y == 0) {
        // Top wall 
        velocity = Vector2(dx, -dy);
      } else if (firstPoint.x == game.size.x) {
        // Right wall
        velocity = Vector2(-dx, dy);
      } else if (firstPoint.y == game.size.y) {
        // Bottom wall
        velocity = Vector2(dx, -dy);
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
    
    position.add(velocity.scaled(dt));

    position.clamp(Vector2(0, 0), Vector2(game.size.x - this.size.x , game.size.y - this.size.y));

    try{
      for(PositionComponent other in activeCollisions){
        if(other is Sand){
        final diffOfX = (other.position.x - position.x);
        final diffOfY = (other.position.y - position.y); 

          if(diffOfX.abs() > diffOfY.abs() && diffOfX.sign == -1){
            //this object x > other object x, therefore RIGHT OF OTHER
            position.clamp(Vector2(other.position.x + other.size.x, 0 ), Vector2(game.size.x - this.size.x , game.size.y - this.size.y));

            if(other.collidingWith(ScreenHitbox())){
              velocity.x = -velocity.x;
            }

          }

          else if(diffOfX.abs() > diffOfY.abs() && diffOfX.sign == 1){
            //this object x > other object x, therefore LEFT OF OTHER
            position.clamp(Vector2(0, 0 ), Vector2(other.position.x - other.size.x, game.size.y - this.size.y));

            if(other.collidingWith(ScreenHitbox())){
              velocity.x = -velocity.x;
            }

          }

          else if(diffOfX.abs() < diffOfY.abs() && diffOfY.sign == -1){
            //this object y > other object y, therefore BELOW OTHER
            position.clamp(Vector2(0, other.position.y+other.size.y ), Vector2(game.size.x - this.size.x, game.size.y - this.size.y));

            if(other.collidingWith(ScreenHitbox())){
              velocity.y = -velocity.y;
            }

          }

          else if(diffOfX.abs() < diffOfY.abs() && diffOfY.sign == 1){
            //this object y < other object y, therefore ABOVE OTHER
            position.clamp(Vector2(0, 0 ), Vector2(game.size.x - this.size.x, other.position.y));

             if(other.collidingWith(ScreenHitbox())){
              velocity.y = -velocity.y;
            }

          }
        }
      }
    }
    catch(exception){
      //print(exception);
    }
    

     //Gravity
    //var gravity = Vector2(0, 500);
    //velocity += gravity;

  }
   
 

   



  


}


 