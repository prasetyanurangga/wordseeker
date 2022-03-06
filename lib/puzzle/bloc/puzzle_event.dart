// ignore_for_file: public_member_api_docs

part of 'puzzle_bloc.dart';

abstract class PuzzleEvent extends Equatable {
  const PuzzleEvent();

  @override
  List<Object> get props => [];
}

class PuzzleInitialized extends PuzzleEvent {
  const PuzzleInitialized({
    required this.shufflePuzzle,
    required this.puzzleLevel,
    required this.playerName,
  });

  final bool shufflePuzzle;
  final PuzzleLevel puzzleLevel;
  final String playerName;

  @override
  List<Object> get props => [shufflePuzzle, puzzleLevel, playerName];
}

class TileTapped extends PuzzleEvent {
  const TileTapped(
    this.tile,{
    required this.puzzleLevel,
  });

  final Tile tile;
  final PuzzleLevel puzzleLevel;

  @override
  List<Object> get props => [tile, puzzleLevel];
}

class PuzzleReset extends PuzzleEvent {
  const PuzzleReset({
    required this.puzzleLevel,
  });

  final PuzzleLevel puzzleLevel;

  @override
  List<Object> get props => [puzzleLevel];
}
