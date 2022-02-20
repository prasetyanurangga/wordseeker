import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'dart:math' as math;
import 'dart:ui';

import 'package:very_good_slide_puzzle/animated_bg/animated_background.dart';
import 'package:very_good_slide_puzzle/audio_control/audio_control.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/simple/simple.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/timer/timer.dart';
import 'package:very_good_slide_puzzle/typography/typography.dart';

class PuzzlePage extends StatelessWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc(
            initialThemes: [
              const SimpleTheme(),
            ],
          ),
        ),
        BlocProvider(
          create: (_) => TimerBloc(
            ticker: const Ticker(),
          ),
        ),
        BlocProvider(
          create: (_) => AudioControlBloc(),
        ),
      ],
      child: PuzzleView(),
    );
  }
}
class PuzzleView extends StatefulWidget {
  PuzzleView({Key? key}) : super(key: key);

  @override
  _PuzzleViewState createState() => new _PuzzleViewState();
}

class _PuzzleViewState extends State<PuzzleView> with TickerProviderStateMixin {

  


  

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    /// Shuffle only if the current theme is Simple.
    final shufflePuzzle = theme is SimpleTheme;

    return Scaffold(
      body: AnimatedContainer(
        duration: PuzzleThemeAnimationDuration.backgroundColorChange,
        decoration: BoxDecoration(color: theme.backgroundColor),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => TimerBloc(
                ticker: const Ticker(),
              ),
            ),
            BlocProvider(
              create: (context) => PuzzleBloc(5)
                ..add(
                  PuzzleInitialized(
                    shufflePuzzle: shufflePuzzle,
                  ),
                ),
            ),
          ],
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackgroundPage(
              child: const _Puzzle(
                key: Key('puzzle_view_puzzle'),
              ),
              isBlur: true
            ),
          ),
        ),
      ),
    );
  }
}

class _Puzzle extends StatelessWidget {
  const _Puzzle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            if (theme is SimpleTheme)
              theme.layoutDelegate.backgroundBuilder(state),
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  children: const [
                    PuzzleSections(),
                  ],
                ),
              ),
            ),
            if (theme is! SimpleTheme)
              theme.layoutDelegate.backgroundBuilder(state),
          ],
        );
      },
    );
  }
}

/// {@template puzzle_header}
/// Displays the header of the puzzle.
/// {@endtemplate}
@visibleForTesting
class PuzzleHeader extends StatelessWidget {
  /// {@macro puzzle_header}
  const PuzzleHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ResponsiveLayoutBuilder(
        small: (context, child) => Stack(
          children: [
            const Align(
              child: PuzzleLogo(),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 34),
                child: AudioControl(key: audioControlKey),
              ),
            ),
          ],
        ),
        medium: (context, child) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              PuzzleLogo(),
            ],
          ),
        ),
        large: (context, child) => Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              PuzzleLogo(),
            ],
          ),
        ),
      ),
    );
  }
}

/// {@template puzzle_logo}
/// Displays the logo of the puzzle.
/// {@endtemplate}
@visibleForTesting
class PuzzleLogo extends StatelessWidget {
  /// {@macro puzzle_logo}
  const PuzzleLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return AppFlutterLogo(
      key: puzzleLogoKey,
      isColored: theme.isLogoColored,
    );
  }
}

/// {@template puzzle_sections}
/// Displays start and end sections of the puzzle.
/// {@endtemplate}
class PuzzleSections extends StatelessWidget {
  /// {@macro puzzle_sections}
  const PuzzleSections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    return ResponsiveLayoutBuilder(
      small: (context, child) => Column(
        children: [
          theme.layoutDelegate.startSectionBuilder(state),
          const PuzzleBoard(),
          theme.layoutDelegate.endSectionBuilder(state),
        ],
      ),
      medium: (context, child) => Column(
        children: [
          theme.layoutDelegate.startSectionBuilder(state),
          const PuzzleBoard(),
          theme.layoutDelegate.endSectionBuilder(state),
        ],
      ),
      large: (context, child) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: theme.layoutDelegate.startSectionBuilder(state),
          ),
          const PuzzleBoard(),
          Expanded(
            child: theme.layoutDelegate.endSectionBuilder(state),
          ),
        ],
      ),
    );
  }
}

/// {@template puzzle_board}
/// Displays the board of the puzzle.
/// {@endtemplate}
@visibleForTesting
class PuzzleBoard extends StatelessWidget {
  /// {@macro puzzle_board}
  const PuzzleBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final puzzle = context.select((PuzzleBloc bloc) => bloc.state.puzzle);

    final size = puzzle.getDimension();
    if (size == 0) return const CircularProgressIndicator();

    return PuzzleKeyboardHandler(
      child: BlocListener<PuzzleBloc, PuzzleState>(
        listener: (context, state) {
          if (state.puzzleStatus == PuzzleStatus.complete) {
            context.read<TimerBloc>().add(const TimerStopped());
          }
        },
        child: theme.layoutDelegate.boardBuilder(
          size,
          puzzle.tiles
            .map(
              (tile) => _PuzzleTile(
                key: Key('puzzle_tile_${tile.value.toString()}'),
                tile: tile,
              ),
            )
            .toList(),
          ),
      ),
    );
  }
}

class _PuzzleTile extends StatelessWidget {
  const _PuzzleTile({
    Key? key,
    required this.tile,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);
    final state = context.select((PuzzleBloc bloc) => bloc.state);

    return tile.isWhitespace
        ? theme.layoutDelegate.whitespaceTileBuilder()
        : theme.layoutDelegate.tileBuilder(tile, state);
  }
}


/// The global key of [PuzzleLogo].
///
/// Used to animate the transition of [PuzzleLogo] when changing a theme.
final puzzleLogoKey = GlobalKey(debugLabel: 'puzzle_logo');

/// The global key of [PuzzleName].
///
/// Used to animate the transition of [PuzzleName] when changing a theme.
final puzzleNameKey = GlobalKey(debugLabel: 'puzzle_name');

/// The global key of [PuzzleTitle].
///
/// Used to animate the transition of [PuzzleTitle] when changing a theme.
final puzzleTitleKey = GlobalKey(debugLabel: 'puzzle_title');

/// The global key of [NumberOfMovesAndTilesLeft].
///
/// Used to animate the transition of [NumberOfMovesAndTilesLeft]
/// when changing a theme.
final numberOfMovesAndTilesLeftKey =
    GlobalKey(debugLabel: 'number_of_moves_and_tiles_left');

/// The global key of [AudioControl].
///
/// Used to animate the transition of [AudioControl]
/// when changing a theme.
final audioControlKey = GlobalKey(debugLabel: 'audio_control');
