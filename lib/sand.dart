
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'dart:math';
import 'sand_game.dart';


//Sand Element
class Sand extends SpriteComponent with HasGameReference<SandGame>, DragCallbacks, CollisionCallbacks, TapCallbacks {

  var velocity =  Vector2.zero();
  List<Sand> hitBy = [];

  Sand() : super(
    anchor: Anchor.topLeft
  
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await game.loadSprite('sand.png');
    final randomX = game.canvasSize.x * Random().nextDouble();
    final randomY = game.canvasSize.y * Random().nextDouble();
    position = Vector2(randomX, randomY);
    size = Vector2(10, 10);
    final hitbox = RectangleHitbox.relative(Vector2(1,1), parentSize: size);

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
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other){
    super.onCollision(intersectionPoints, other);

    if (other is Sand && (!hitBy.contains(other) || !other.hitBy.contains(this)) ){

      /*
      other.hitBy.add(this);
      hitBy.add(other);
      final velocitySum = (velocity + other.velocity).scaled(0.5);
      velocity = velocitySum;
      other.velocity = velocitySum;*/

      double restitutionCoefficient = 1;

      final initialVelocity = velocity;
      final initialOtherVelocity = other.velocity;



      velocity = initialVelocity - (position-other.position) *  restitutionCoefficient * 0.5 * (((initialVelocity-initialOtherVelocity).dot(position-other.position))/(position-other.position).length2); 

      other.velocity = initialOtherVelocity - (other.position - position) * restitutionCoefficient * 0.5 * (((initialOtherVelocity-initialVelocity).dot(other.position-position))/((other.position - position).length2));

      //velocity = (initialOtherVelocity-initialVelocity)*restitutionCoefficient*0.5 + initialVelocity*0.5 + initialOtherVelocity*0.5;
      //other.velocity = (initialVelocity - initialOtherVelocity)*restitutionCoefficient*0.5 + initialVelocity*0.5 + initialOtherVelocity*0.5;

      other.hitBy.add(this);
      hitBy.add(other);
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
  void onTapDown(TapDownEvent event) {
    velocity = Vector2.zero();
    super.onTapDown(event);
  }



  


  @override
  void update(double dt){
    super.update(dt);
    
    position.add(velocity.scaled(dt));
    position.clamp(Vector2(0, 0), Vector2(game.size.x - size.x , game.size.y - size.y));

    try{
      for(PositionComponent other in activeCollisions){
        if(other is Sand){
        final diffOfX = (other.position.x - position.x);
        final diffOfY = (other.position.y - position.y); 

          if(diffOfX.abs() > diffOfY.abs() && diffOfX.sign == -1){
            //this object x > other object x, therefore RIGHT OF OTHER
            position.clamp(Vector2(other.position.x + other.size.x, 0 ), Vector2(game.size.x - size.x , game.size.y - size.y));
          }

          else if(diffOfX.abs() > diffOfY.abs() && diffOfX.sign == 1){
            //this object x > other object x, therefore LEFT OF OTHER
            position.clamp(Vector2(0, 0 ), Vector2(other.position.x - other.size.x, game.size.y - size.y));
          }

          else if(diffOfX.abs() < diffOfY.abs() && diffOfY.sign == -1){
            //this object y > other object y, therefore BELOW OTHER
            position.clamp(Vector2(0, other.position.y+other.size.y ), Vector2(game.size.x - size.x, game.size.y - size.y));
          }

          else if(diffOfX.abs() < diffOfY.abs() && diffOfY.sign == 1){
            //this object y < other object y, therefore ABOVE OTHER
            position.clamp(Vector2(0, 0 ), Vector2(game.size.x - size.x, other.position.y));
          }
        }
      }
    }
    catch(exception){
      //print(exception);
    }
    

     //Gravity
    //final gravity = Vector2(0, 500);
    //velocity += gravity;

  }
   
 

   



  


}


 