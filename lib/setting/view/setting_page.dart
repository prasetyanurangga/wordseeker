import 'package:flutter/material.dart';

import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/typography/typography.dart';
import 'dart:math' as math;
import 'dart:ui';
import 'package:gap/gap.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/component/simple_button.dart';
import 'package:very_good_slide_puzzle/component/simple_textfield.dart';
import 'package:very_good_slide_puzzle/component/simple_choose_button.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/router/router_name.dart';
import 'package:very_good_slide_puzzle/router/router_generator.dart';
import 'package:qlevar_router/qlevar_router.dart';


class SettingPage extends StatefulWidget {
  SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => new _SettingPageState();
}

class _SettingPageState extends State<SettingPage>{

  PuzzleLevel _puzzleLevel = PuzzleLevel.easy;
  String _playerName = "";
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: BackgroundPage(
        isBlur: true,
        child : LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Center(
                  child: Container(
                    width: 480,
                    child : Column(
                        children: [

                          AnimatedDefaultTextStyle(
                            style: PuzzleTextStyle.body.copyWith(
                              color: Color(0xFF505871),
                            ),
                            duration: PuzzleThemeAnimationDuration.textStyle,
                            child: Text(
                              "But before we start, let we know who you are",
                              textAlign: TextAlign.center,
                            ),
                          ), 

                          Gap(24),

                          SimpleTextField(
                            onChange: (String value) {
                              print(value);
                              setState((){
                                 _playerName = value;
                              });
                            },
                            hintText: "Enter your nickname here..."
                          ),

                          Gap(32),
                          AnimatedDefaultTextStyle(
                            style: PuzzleTextStyle.body.copyWith(
                              color: Color(0xFF505871),
                            ),
                            duration: PuzzleThemeAnimationDuration.textStyle,
                            child: Text(
                              "and also, choose the level of puzzle:",
                              textAlign: TextAlign.center,
                            ),
                          ), 
                          Gap(32),


                          SimpleChooseButton(
                            onChange: (PuzzleLevel level) {
                              setState((){
                                  _puzzleLevel = level;
                              });
                            }
                          ),


                          Gap(72),

                          SimpleButton(
                            disable: _playerName == "" ? true : false,
                            textColor: PuzzleColors.primary0,
                            backgroundColor: PuzzleColors.primary6,
                            onPressed: () {

                                String level = "easy";

                                if(_puzzleLevel == PuzzleLevel.easy){
                                  level = "easy";
                                } else if(_puzzleLevel == PuzzleLevel.medium){
                                  level = "medium";
                                } else if(_puzzleLevel == PuzzleLevel.hard){
                                  level = "hard";
                                }

                                QR.navigator.replaceAllWithName(RoutesName.PUZZLE_PAGE,
                                  params: {
                                    'player_name':_playerName,
                                    'puzzle_level': level
                                  });
                              
                                
                              
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Start Puzzle"),
                              ],
                            ),
                          )
                      ]
                    )
                  )
                )
              ),
            );
          },
        ),
      )
    );
  }
}