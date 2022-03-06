// ignore_for_file: public_member_api_docs

import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:very_good_slide_puzzle/models/models.dart';

part 'puzzle_event.dart';
part 'puzzle_state.dart';

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  PuzzleBloc(this._size, {this.random}) : super(const PuzzleState()) {
    on<PuzzleInitialized>(_onPuzzleInitialized);
    on<TileTapped>(_onTileTapped);
    on<PuzzleReset>(_onPuzzleReset);
  }

  List bunchOfWords4 = [
    "YOUR",
    "READ",
    "BEAR",
    "RARE",
    "SCAM",
    "NEAR",
    "FEAR",
    "DOWN",
    "NAME",
    "FAME",
    "SAME",
    "DONE",
    "CHAR",
    "VERY",
    "FAIR",
    "SAIL",
    "SALE",
    "FAIL",
    "FILE",
    "DEAL",
    "NAIL",
    "SOIL",
    "FLOW",
    "BOWL",
    "VEIL",
    "DOLL",
    "HUSK",
    "LOSE"
  ];

  List bunchOfWord5 = [
    "HOUSE",
    "FORCE",
    "BUNNY",
    "POWER",
    "WORLD",
    "FANCY",
    "FAIRY",
    "BEACH",
    "TOWER"

  ];

  Map generateWordLevel(){
    List<String> result = [];
    final _random = new Random();
    List<String> bunchOfWordChoose = [];
    List bunchOfLetterCount = [];
    Random random = new Random();
    while(bunchOfWordChoose.length < 4){
      String random_world =  bunchOfWord5[random.nextInt(bunchOfWord5.length)];
      if (!bunchOfWordChoose.contains(random_world)) {
        bunchOfWordChoose.add(random_world);
      }
    }

    String random_world_4_digit =  bunchOfWords4[random.nextInt(bunchOfWords4.length)];

    for(String item in bunchOfWordChoose){
      var letter = item.split('');
      result = [result, letter].expand((x) => x).toList();
      var map = Map();

      letter.forEach((element) {
        if(!map.containsKey(element)) {
          map[element] = 1;
        } else {
          map[element] +=1;
        }
      });

      bunchOfLetterCount.add(map);
    }

    var letter4 = random_world_4_digit.split('');
    var map4 = Map();

    letter4.forEach((element) {
      if(!map4.containsKey(element)) {
        map4[element] = 1;
      } else {
        map4[element] +=1;
      }
    });

    result = [result, letter4].expand((x) => x).toList();
    bunchOfLetterCount.add(map4);
    return {
      'data' : result,
      'count': bunchOfLetterCount
    };
  }




  final int _size;

  final Random? random;

  void _onPuzzleInitialized(
    PuzzleInitialized event,
    Emitter<PuzzleState> emit,
  ) {

    var bunchOfData = generateWordLevel();
    List<String> bunchOfString = bunchOfData['data'];
    final puzzle = _generatePuzzle(_size, shuffle: event.shufflePuzzle, level : event.puzzleLevel);
    emit(
      PuzzleState(
        puzzle: puzzle.sort(),
        numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
        playerName: event.playerName,
        puzzleLevel: event.puzzleLevel
      ),
    );
  }

  void _onTileTapped(TileTapped event, Emitter<PuzzleState> emit) {
    final tappedTile = event.tile;
    if (state.puzzleStatus == PuzzleStatus.incomplete) {
      if (state.puzzle.isTileMovable(tappedTile)) {
        final mutablePuzzle = Puzzle(tiles: [...state.puzzle.tiles], countLetter :state.puzzle.countLetter,  puzzleLevel: state.puzzleLevel);
        final puzzle = mutablePuzzle.moveTiles(tappedTile, []);
        if (puzzle.isComplete()) {
          emit(
            state.copyWith(
              puzzle: puzzle.sort(),
              puzzleStatus: PuzzleStatus.complete,
              tileMovementStatus: TileMovementStatus.moved,
              numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
              numberOfMoves: state.numberOfMoves + 1,
              lastTappedTile: tappedTile,
              playerName: state.playerName,
              puzzleLevel: state.puzzleLevel
            ),
          );
        } else {
          emit(
            state.copyWith(
              puzzle: puzzle.sort(),
              tileMovementStatus: TileMovementStatus.moved,
              numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
              numberOfMoves: state.numberOfMoves + 1,
              lastTappedTile: tappedTile,
              playerName: state.playerName,
              puzzleLevel: state.puzzleLevel
            ),
          );
        }
      } else {
        emit(
          state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
        );
      }
    } else {
      emit(
        state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
      );
    }
  }

  void _onPuzzleReset(PuzzleReset event, Emitter<PuzzleState> emit) {
    final puzzle = _generatePuzzle(_size, level: event.puzzleLevel);
    emit(
      PuzzleState(
        puzzle: puzzle.sort(),
        numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
      ),
    );
  }

  /// Build a randomized, solvable puzzle of the given size.
  Puzzle _generatePuzzle(int size, {bool shuffle = true, PuzzleLevel level: PuzzleLevel.easy}) {
    final correctPositions = <Position>[];
    final currentPositions = <Position>[];
    final whitespacePosition = Position(x: size, y: size);

    // Create all possible board positions.
    for (var y = 1; y <= size; y++) {
      for (var x = 1; x <= size; x++) {
        if (x == size && y == size) {
          correctPositions.add(whitespacePosition);
          currentPositions.add(whitespacePosition);
        } else {
          final position = Position(x: x, y: y);
          correctPositions.add(position);
          currentPositions.add(position);
        }
      }
    }

    if (shuffle) {
      // Randomize only the current tile posistions.
      currentPositions.shuffle(random);
    }


   var bunchOfData = generateWordLevel();
   var bunchOfWord = bunchOfData['data'];

   var bunchOfCountWord = bunchOfData['count'];

   print(bunchOfCountWord);

    var tiles = _getTileListFromPositions(
      size,
      correctPositions,
      currentPositions,
      bunchOfWord
    );

    var puzzle = Puzzle(tiles: tiles, countLetter: bunchOfCountWord, puzzleLevel: level);

    if (shuffle) {
      // Assign the tiles new current positions until the puzzle is solvable and
      // zero tiles are in their correct position.
      while (!puzzle.isSolvable() || puzzle.getNumberOfCorrectTiles() != 0) {
        currentPositions.shuffle(random);
        tiles = _getTileListFromPositions(
          size,
          correctPositions,
          currentPositions,
          bunchOfWord
        );
        puzzle = Puzzle(tiles: tiles, countLetter: bunchOfCountWord, puzzleLevel: level);
      }
    }

    return puzzle;
  }

  /// Build a list of tiles - giving each tile their correct position and a
  /// current position.
  List<Tile> _getTileListFromPositions(
    int size,
    List<Position> correctPositions,
    List<Position> currentPositions,
    List<String> bunchOfWord
  ) {
    final whitespacePosition = Position(x: size, y: size);


    return [
      for (int i = 1; i <= size * size; i++)
        if (i == size * size)
          Tile(
            text: 'f',
            value: i,
            correctPosition: whitespacePosition,
            currentPosition: currentPositions[i - 1],
            isWhitespace: true
          )
        else
          Tile(
            text: bunchOfWord[i-1],
            value: i,
            correctPosition: correctPositions[i - 1],
            currentPosition: currentPositions[i - 1]
          )
    ];
  }
}
