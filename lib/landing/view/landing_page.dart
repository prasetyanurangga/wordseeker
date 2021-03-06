import 'package:flutter/material.dart';

import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/typography/typography.dart';
import 'dart:math' as math;
import 'dart:ui';
import 'package:gap/gap.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/component/simple_button.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/router/router_name.dart';
import 'package:qlevar_router/qlevar_router.dart';


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
                    width: 480,
                    child : Column(
                        children: [

                          AnimatedDefaultTextStyle(
                            style: PuzzleTextStyle.body.copyWith(
                              color: Color(0xFF505871),
                            ),
                            duration: PuzzleThemeAnimationDuration.textStyle,
                            child: Text(
                              "Do you feel smart enough to",
                              textAlign: TextAlign.center,
                            ),
                          ), 

                          Gap(16),

                          AnimatedDefaultTextStyle(
                            style: PuzzleTextStyle.headline1,
                            duration: PuzzleThemeAnimationDuration.textStyle,
                            child: Text(
                              "WORD SEEKING?",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Gap(16),
                          AnimatedDefaultTextStyle(
                            style: PuzzleTextStyle.body.copyWith(
                              color: Color(0xFF505871),
                            ),
                            duration: PuzzleThemeAnimationDuration.textStyle,
                            child: Text(
                              "Welcome to ???Wordseeker??? puzzle game and try to search all the words as much as you can!",
                              textAlign: TextAlign.center,
                            ),
                          ), 


                          Gap(72),

                          SimpleButton(
                            textColor: PuzzleColors.primary0,
                            backgroundColor: PuzzleColors.primary6,
                            onPressed: () {
                              QR.toName(RoutesName.SETTING_PAGE);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Try to seek!"),
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