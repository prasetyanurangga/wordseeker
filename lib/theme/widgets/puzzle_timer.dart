import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/typography/typography.dart';

class PuzzleTimer extends StatelessWidget {
  const PuzzleTimer({
    Key? key,
    required this.title,
    this.color,
  }) : super(key: key);

  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final titleColor = color ?? theme.titleColor;

    return ResponsiveLayoutBuilder(
      small: (context, child) => Center(
        child: SizedBox(
          width: 300,
          child: Center(
            child: child,
          ),
        ),
      ),
      medium: (context, child) => Center(
        child: child,
      ),
      large: (context, child) => SizedBox(
        width: 300,
        child: child,
      ),
      child: (currentSize) {
        final bodyTextStyle = currentSize == ResponsiveLayoutSize.small
            ? PuzzleTextStyle.bodySmall
            : PuzzleTextStyle.body;

        final textAlign = currentSize == ResponsiveLayoutSize.small
            ? TextAlign.center
            : TextAlign.left;

        return AnimatedDefaultTextStyle(
          style: bodyTextStyle.copyWith(
            color: titleColor,
          ),
          duration: PuzzleThemeAnimationDuration.textStyle,
          child: Text(
            title,
            textAlign: textAlign,
          ),
        );
      },
    );
  }
}
