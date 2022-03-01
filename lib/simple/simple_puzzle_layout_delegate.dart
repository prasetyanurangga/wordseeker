import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:very_good_slide_puzzle/colors/colors.dart';
import 'package:very_good_slide_puzzle/l10n/l10n.dart';
import 'package:very_good_slide_puzzle/layout/layout.dart';
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart';
import 'package:very_good_slide_puzzle/simple/simple.dart';
import 'package:very_good_slide_puzzle/theme/theme.dart';
import 'package:very_good_slide_puzzle/typography/typography.dart';
import 'package:very_good_slide_puzzle/timer/timer.dart';


class SimplePuzzleLayoutDelegate extends PuzzleLayoutDelegate {

  const SimplePuzzleLayoutDelegate();

  @override
  Widget startSectionBuilder(PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, child) => child!,
      medium: (_, child) => child!,
      large: (_, child) => Padding(
        padding: const EdgeInsets.only(left: 50, right: 32),
        child: child,
      ),
      child: (_) => SimpleStartSection(state: state),
    );
  }

  @override
  Widget endSectionBuilder(PuzzleState state) {
    return Column(
      children: [
        const ResponsiveGap(
          small: 32,
          medium: 48,
        ),
        ResponsiveLayoutBuilder(
          small: (_, child) => const SimplePuzzleShuffleButton(),
          medium: (_, child) => const SimplePuzzleShuffleButton(),
          large: (_, __) => const SizedBox(),
        ),
        const ResponsiveGap(
          small: 32,
          medium: 48,
        ),
      ],
    );
  }

  @override
  Widget backgroundBuilder(PuzzleState state) {
    return Positioned(
      right: 0,
      bottom: 0,
      child: ResponsiveLayoutBuilder(
        small: (_, __) => Container(),
        medium: (_, __) => Container(),
        large: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 53),
          child: Container(),
        ),
      ),
    );
  }

  @override
  Widget boardBuilder(int size, List<Widget> tiles) {
    return Column(
      children: [
        const ResponsiveGap(
          small: 32,
          medium: 48,
          large: 96,
        ),
        ResponsiveLayoutBuilder(
          small: (_, __) => Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                width: _BoardSize.small + 24,
                height: _BoardSize.small + 24,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
              ), 

              Container(
                padding: EdgeInsets.all(12),
                child: SizedBox.square(
                  dimension: _BoardSize.small,
                  child: SimplePuzzleBoard(
                    key: const Key('simple_puzzle_board_small'),
                    size: size,
                    tiles: tiles,
                    spacing: 5,
                  ),
                )
              )
            ]
          ),
          medium: (_, __) => Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                width: _BoardSize.medium + 24,
                height: _BoardSize.medium + 24,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
              ), 

              Container(
                padding: EdgeInsets.all(12),
                child: SizedBox.square(
                  dimension: _BoardSize.medium,
                  child: SimplePuzzleBoard(
                    key: const Key('simple_puzzle_board_medium'),
                    size: size,
                    tiles: tiles,
                    spacing: 5,
                  ),
                )
              )
            ]
          ),

          large: (_, __) => Stack(
            children: [


              Positioned(
                top: 0,
                left: 0,
                width: _BoardSize.large + 32,
                height: _BoardSize.large + 32,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight, 
                          end: Alignment.topLeft, 
                          colors: [
                            Color(0xFF2F9AB2).withOpacity(0.08),
                            Color(0xFF2F6EB2).withOpacity(0.08)
                          ]
                        )
                      ),
                    ),
                  ),
                ),
              ), 

              Container(
                padding: EdgeInsets.all(16),
                child: SizedBox.square(
                  dimension: _BoardSize.large,
                  child: SimplePuzzleBoard(
                    key: const Key('simple_puzzle_board_large'),
                    size: size,
                    tiles: tiles,
                    spacing: 8,
                  ),
                )
              )
            ]
          )
        ),
        const ResponsiveGap(
          large: 96,
        ),
      ],
    );
  }

  @override
  Widget tileBuilder(Tile tile, PuzzleState state) {
    return ResponsiveLayoutBuilder(
      small: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_small'),
        tile: tile,
        tileFontSize: _TileFontSize.small,
        state: state,
      ),
      medium: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_medium'),
        tile: tile,
        tileFontSize: _TileFontSize.medium,
        state: state,
      ),
      large: (_, __) => SimplePuzzleTile(
        key: Key('simple_puzzle_tile_${tile.value}_large'),
        tile: tile,
        tileFontSize: _TileFontSize.large,
        state: state,
      ),
    );
  }

  @override
  Widget whitespaceTileBuilder() {
    return const SizedBox();
  }

  @override
  List<Object?> get props => [];
}

/// {@template simple_start_section}
/// Displays the start section of the puzzle based on [state].
/// {@endtemplate}
@visibleForTesting
class SimpleStartSection extends StatelessWidget {
  /// {@macro simple_start_section}
  const SimpleStartSection({
    Key? key,
    required this.state,
  }) : super(key: key);

  /// The state of the puzzle.
  final PuzzleState state;

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ResponsiveGap(
          small: 20,
          medium: 83,
          large: 151,
        ),
        PuzzleTimer(
          title: state.playerName,
          color: Colors.black
        ),
        const ResponsiveGap(large: 16),
        SimplePuzzleTitle(
          status: state.puzzleStatus,
        ),
        const ResponsiveGap(
          small: 12,
          medium: 16,
          large: 32,
        ),
        Container(
          child: BlocBuilder<TimerBloc, TimerState>(
            builder: (context, state) {
              if (state.isRunning && state.secondsElapsed > 0) {
                final now = Duration(seconds: state.secondsElapsed);
                return PuzzleTimer(
                  title: _printDuration(now),
                  color: Colors.black
                );
              } else {
                return PuzzleTimer(
                  title: "00:00:00",
                  color: Colors.black
                );
              }
            },
          ),
        ),
        const ResponsiveGap(
          large: 32,
          small: 16,
        ),
        ResponsiveLayoutBuilder(
          small: (_, __) => const SizedBox(),
          medium: (_, __) => const SizedBox(),
          large: (_, __) => const SimplePuzzleShuffleButton(),
        ),
      ],
    );
  }
}

/// {@template simple_puzzle_title}
/// Displays the title of the puzzle based on [status].
///
/// Shows the success state when the puzzle is completed,
/// otherwise defaults to the Puzzle Challenge title.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleTitle extends StatelessWidget {
  /// {@macro simple_puzzle_title}
  const SimplePuzzleTitle({
    Key? key,
    required this.status,
  }) : super(key: key);

  /// The status of the puzzle.
  final PuzzleStatus status;

  @override
  Widget build(BuildContext context) {
    return PuzzleTitle(
      key: puzzleTitleKey,
      title: status == PuzzleStatus.complete
          ? context.l10n.puzzleCompleted
          : context.l10n.puzzleChallengeTitle,
    );
  }
}

abstract class _BoardSize {
  static double small = 312;
  static double medium = 424;
  static double large = 472;
}

/// {@template simple_puzzle_board}
/// Display the board of the puzzle in a [size]x[size] layout
/// filled with [tiles]. Each tile is spaced with [spacing].
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleBoard extends StatelessWidget {
  /// {@macro simple_puzzle_board}
  const SimplePuzzleBoard({
    Key? key,
    required this.size,
    required this.tiles,
    this.spacing = 8,
  }) : super(key: key);

  /// The size of the board.
  final int size;

  /// The tiles to be displayed on the board.
  final List<Widget> tiles;

  /// The spacing between each tile from [tiles].
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: size,
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      children: tiles,
    );
  }
}

abstract class _TileFontSize {
  static double small = 36;
  static double medium = 50;
  static double large = 54;
}

enum StatusTile { 
  correctXY, 
  correctY, 
  inCorrect 
}

class SimplePuzzleTile extends StatelessWidget {
  /// {@macro simple_puzzle_tile}
  const SimplePuzzleTile({
    Key? key,
    required this.tile,
    required this.tileFontSize,
    required this.state,
  }) : super(key: key);

  /// The tile to be displayed.
  final Tile tile;

  /// The font size of the tile to be displayed.
  final double tileFontSize;

  /// The state of the puzzle.
  final PuzzleState state;

  StatusTile getStatusTile(){
    var tiles = state.puzzle.tiles;
    var countLetter = state.puzzle.countLetter;
    var currentY = countLetter[tile.currentPosition.y - 1];

    var currentCount = currentY.containsKey(tile.text) ? currentY[tile.text] : 0;

    List bunchTilesOtherY = tiles.where((element) => element.text == tile.text && (element.currentPosition.y == tile.currentPosition.y)).toList();
    List bunchTilesOther = tiles.where((element) => element.text == tile.text && element.correctPosition.y == tile.currentPosition.y && element.correctPosition.x == tile.currentPosition.x).toList();

    var countCorrectThisY = 0;
    tiles.forEach((element) {
      tiles.forEach((elementItem) {
          if(elementItem.text == element.text && elementItem.correctPosition.y == element.currentPosition.y && elementItem.correctPosition.x == element.currentPosition.x && tile.currentPosition.y == element.currentPosition.y && tile.text == element.text){
          countCorrectThisY++;
          }
      });
    });

    if ((tile.correctPosition.y == tile.currentPosition.y && tile.correctPosition.x == tile.currentPosition.x) || (bunchTilesOther.length > 0)) {
      // return Color(0xFF2FB293);
      return StatusTile.correctXY;
    } else if (bunchTilesOtherY.length > 0 && currentCount > 0) {
      if(((bunchTilesOtherY.length > currentCount && bunchTilesOtherY[0].currentPosition.x == tile.currentPosition.x) || bunchTilesOtherY.length <= currentCount) && (currentCount - countCorrectThisY) > 0){
        // return PuzzleColors.yellowPastel;
        return StatusTile.correctY;
      } else {
        
        return StatusTile.inCorrect;
      }
      
    }  else {
      return StatusTile.inCorrect;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.select((ThemeBloc bloc) => bloc.state.theme);

    return TextButton(
      style: TextButton.styleFrom(
        primary: PuzzleColors.white,
        textStyle: PuzzleTextStyle.headline2.copyWith(
          fontSize: tileFontSize,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          side: BorderSide(color: Colors.white, width: 2)

        ),
      ).copyWith(
        foregroundColor: MaterialStateProperty.resolveWith<Color?>(
          (states) {
            var statusTile = getStatusTile();
            if(statusTile == StatusTile.correctXY || statusTile == StatusTile.correctY){
              return Colors.white;
            } else {
              return Colors.black;
            }
          },
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (states) {
            var statusTile = getStatusTile();

            if(statusTile == StatusTile.correctXY){
              return Color(0xFF2FB293);
            } else if(statusTile == StatusTile.correctY){
              return PuzzleColors.yellowPastel;
            } else {
              return Colors.white;
            }
          },
        ),
      ),
      onPressed: () {
        if(state.puzzleStatus == PuzzleStatus.incomplete){
          context.read<PuzzleBloc>().add(TileTapped(tile));
        }

        if(state.numberOfMoves == 0){
          context.read<TimerBloc>().add(TimerStarted());
        }
      },
      child: Text(
        tile.text.toString(),
        semanticsLabel: context.l10n.puzzleTileLabelText(
          tile.text.toString(),
          tile.currentPosition.x.toString(),
          tile.currentPosition.y.toString(),
        ),
      ),
    );
  }
}

/// {@template puzzle_shuffle_button}
/// Displays the button to shuffle the puzzle.
/// {@endtemplate}
@visibleForTesting
class SimplePuzzleShuffleButton extends StatelessWidget {
  /// {@macro puzzle_shuffle_button}
  const SimplePuzzleShuffleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PuzzleButton(
      textColor: PuzzleColors.primary0,
      backgroundColor: PuzzleColors.primary6,
      onPressed: () {
        context.read<PuzzleBloc>().add(const PuzzleReset());
        context.read<TimerBloc>().add(const TimerReset());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/shuffle_icon.png',
            width: 17,
            height: 17,
          ),
          const Gap(10),
          Text(context.l10n.puzzleShuffle),
        ],
      ),
    );
  }
}
