import 'package:flutter/material.dart';

import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/typography/typography.dart';
import 'dart:math' as math;
import 'dart:ui';


class LandingPage extends StatefulWidget {
  LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => new _LandingPageState();
}

class _LandingPageState extends State<LandingPage>{

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: BackgroundPage(
        child : LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Center(
                  child: Container(
                    child : Column(
                        children: [

                          AnimatedDefaultTextStyle(
                            style: PuzzleTextStyle.body.copyWith(
                              color: Colors(0xFFDDDDDD),
                            ),
                            duration: PuzzleThemeAnimationDuration.textStyle,
                            child: Text(
                              "Do you feel smart enough to",
                              textAlign: TextAlign.center,
                            ),
                          ), 

                          AnimatedDefaultTextStyle(
                            style: PuzzleTextStyle.headline1,
                            duration: PuzzleThemeAnimationDuration.textStyle,
                            child: Text(
                              "WORD SEEKING?",
                              textAlign: TextAlign.center,
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