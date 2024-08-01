import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:sand_v1/settings_menu.dart';
import 'sand_game.dart';


void main() {
  final sandGame = SandGame();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: 
        GameWidget(     
          game: sandGame,
          overlayBuilderMap: {
            'Settings': (_, game) => SettingsMenu(game: sandGame),
          }
        )
    )
  );
}


//Game


class Background extends RectangleComponent{
   @override
  Future<void> onLoad() async {
    await super.onLoad();
  }
}