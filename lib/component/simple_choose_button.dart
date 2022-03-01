import 'package:flutter/material.dart';

import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/typography/typography.dart';
import 'dart:math' as math;
import 'dart:ui';
import 'package:gap/gap.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/component/simple_button.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/router/router_name.dart';


class SimpleChooseButton extends StatefulWidget {
  SimpleChooseButton({
    Key? key,
    required this.onChange
  }) : super(key: key);


  final Function onChange;

  @override
  _SimpleChooseButtonState createState() => new _SimpleChooseButtonState();
}

class _SimpleChooseButtonState extends State<SimpleChooseButton>{

  PuzzleLevel level = PuzzleLevel.easy;

  ButtonStyle getButtonStyle(PuzzleLevel puzzleLevel){
    if(puzzleLevel == level){
      return OutlinedButton.styleFrom(
        primary: Color(0xFF2447A3),
        backgroundColor: Colors.transparent,
        side: BorderSide(color: Color(0xFF2447A3), width: 2),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      );
    } else {
      return OutlinedButton.styleFrom(
        primary: Color(0xFF0E121E),
        backgroundColor: Colors.transparent,
        side: BorderSide(color: Color(0xFFD1DAE6), width: 2),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Row(
        children:[
          Expanded(
            child : OutlinedButton(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12,  vertical: 16),
                  child :Text('Easy')
              ),
              style: getButtonStyle(PuzzleLevel.easy),
              onPressed: () {
                widget.onChange(PuzzleLevel.easy);
                setState(() {
                  level = PuzzleLevel.easy;
                });
              },
            )
          ),

          Gap(24),
          Expanded(
            child : OutlinedButton(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12,  vertical: 16),
                  child :Text('Medium')
              ),
              style: getButtonStyle(PuzzleLevel.medium),
              onPressed: () {
                widget.onChange(PuzzleLevel.medium);
                setState(() {
                  level = PuzzleLevel.medium;
                });
              },
            )
          ),
          Gap(24),
          Expanded(
            child : OutlinedButton(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12,  vertical: 16),
                  child :Text('Hard')
              ),
              style: getButtonStyle(PuzzleLevel.hard),
              onPressed: () {
                widget.onChange(PuzzleLevel.hard);
                setState(() {
                  level = PuzzleLevel.hard;
                });
              },
            )
          )
        ]
      ),
    );
  }
}