import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:sand_v1/sand_game.dart';

class MenuButton extends SpriteButtonComponent with DragCallbacks, HasGameReference<SandGame>, CollisionCallbacks{

  var velocity = Vector2.zero();


  MenuButton({
    super.button,
    super.buttonDown,
    super.onPressed,
    super.position,
    super.size,
    super.anchor,
    super.angle,
    super.children,
    super.priority,
    super.scale

  }){priority = 1;}

//moves a component to the corner
  void setCornerPosition(PositionComponent component, Vector2 gameSize){
    component.position = Vector2(gameSize.x * 0.97 , gameSize.y * 0.05 );
  }

   @override
  Future<void> onLoad() async  {
    super.onLoad();

    anchor = Anchor.center;

    //setCornerPosition(this, game.canvasSize);

    position.setZero();


    final hitbox = RectangleHitbox.relative(Vector2(1,1), parentSize: size);
    add(hitbox);

  }


  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    //setCornerPosition(this, size);
    position.setZero();


    velocity.setZero();
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
  void update(double dt){
    super.update(dt);

    velocity = velocity - velocity.normalized() * velocity.length2 * 0.001 * dt; 

    position.add(velocity.scaled(dt));
    position.clamp(Vector2(size.x * 0.5, size.y * 0.5), Vector2(game.size.x - size.x * 0.5 , game.size.y - size.y * 0.5));

  
    
  }




  
}