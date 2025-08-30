import 'package:flutter/material.dart';
import 'package:sand_v1/sand_game.dart';

class SettingsMenu extends StatefulWidget{
    // Reference to parent game.
  final SandGame game;
  const SettingsMenu({super.key, required this.game});
  
  @override
  State<StatefulWidget> createState() => _SettingsState();
    
}


class _SettingsState extends State<SettingsMenu>{
  late double numberOfSand;
  late double sizeOfSand;

  @override
  void initState() {
    super.initState();
    numberOfSand = widget.game.getSandAmount();
    sizeOfSand = widget.game.getSandSize();

  }
 
   @override
  Widget build(BuildContext context) {

    const blackTextColor = Color.fromRGBO(0, 0, 0, 1.0);
    const whiteTextColor = Color.fromRGBO(255, 255, 255, 1.0);

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 400,
          width: 300,
          decoration: const BoxDecoration(
            color: blackTextColor,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ 

              const Text(
                    'Sand Count',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: whiteTextColor,
                    ),
                  ),

               Slider(
                value: numberOfSand,
                onChanged: (double newValue){

                  setState(() {
                    numberOfSand = newValue.roundToDouble();
                  });
                 
                  widget.game.changeAmountOfSand(newValue.round());
                },
                max: 300,
                min: 1,
              
                ),

                const Text(
                    'Sand Size',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: whiteTextColor,
                    ),
                  ),

               Slider(
                value: sizeOfSand,
                onChanged: (double newValue){

                  setState(() {
                    sizeOfSand = newValue.roundToDouble();
                  });
                 
                  widget.game.changeSizeOfSand(newValue);
                },
                max: 100,
                min: 1,
              
                ),

              const SizedBox(height: 40),
              SizedBox(
                width: 200,
                height: 75,
                child: ElevatedButton(
                  onPressed: () {
                    widget.game.reset();
                    widget.game.overlays.remove('Settings');
                    
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteTextColor,
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 28.0,
                      color: blackTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  

}

