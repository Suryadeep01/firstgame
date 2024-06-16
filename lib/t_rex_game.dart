import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class TRexGame extends FlameGame with TapDetector {
  late SpriteComponent tRex;
  SpriteComponent? obstacle;
  bool isJumping = false;
  double jumpVelocity = -600;
  double gravity = 1000;
  double obstacleSpeed = 200; // Speed at which the obstacle moves
  bool isGameOver = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    startGame();
  }

  Future<void> startGame() async {
    isGameOver = false;
    jumpVelocity = -600;
    isJumping = false;

    // Load T-Rex
    tRex = SpriteComponent()
      ..sprite = await loadSprite('t_rex.png')
      ..size = Vector2(100, 100)  // Increased size
      ..position = Vector2(50, size.y - 150); // Adjusted position for increased size
    add(tRex);

    // Load Obstacle
    obstacle = SpriteComponent()
      ..sprite = await loadSprite('obstacle.png')
      ..size = Vector2(50, 50)  // Increased size
      ..position = Vector2(size.x, size.y - 100); // Starting position off-screen to the right
    add(obstacle!);
  }

  void jump() {
    if (!isJumping && !isGameOver) {
      isJumping = true;
      jumpVelocity = -600;  // Initial jump velocity
    }
  }

  @override
  void onTap() {
    if (isGameOver) {
      // Remove existing components before restarting the game
      remove(tRex);
      remove(obstacle!);
      startGame();
    } else {
      jump();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isGameOver) return;

    // Update T-Rex position
    if (isJumping) {
      tRex.y += jumpVelocity * dt;
      jumpVelocity += gravity * dt;

      if (tRex.y >= size.y - 150) {
        tRex.y = size.y - 150;
        isJumping = false;
      }
    }

    // Update Obstacle position
    obstacle?.x -= obstacleSpeed * dt;

    // Reset obstacle position when it goes off-screen
    if (obstacle != null && obstacle!.x < -obstacle!.size.x) {
      obstacle!.x = size.x;
    }

    // Check for collision
    if (obstacle != null && tRex.toRect().overlaps(obstacle!.toRect())) {
      // Handle collision (e.g., reset game, decrease score, etc.)
      isGameOver = true;
      print('Game Over!');
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (isGameOver) {
      TextPainter painter = TextPainter(
        text: TextSpan(
          text: 'Game Over! Tap to Play Again',
          style: TextStyle(
            color: Colors.red,
            fontSize: 30,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      painter.layout();
      painter.paint(canvas, Offset(size.x / 2 - painter.width / 2, size.y / 2 - painter.height / 2));
    }
  }
}
