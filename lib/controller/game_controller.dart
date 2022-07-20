import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mems_game/model/player.dart';

enum GameState { play, end }

class GameController extends GetxController {
  bool _palyerMode = false;
  var _players = Rx<List<Player>>([]).obs;
  Player? currentPlayer;
  List<String> _questions = [];
  List<String> _usedQuestions = [];
  RxInt _currentQuestIndex = (-1).obs;
  RxBool _isLoadQuestions = false.obs;
  PageController _pageController = PageController();
  var _gameState = Rx<GameState>(GameState.end).obs;

  PageController get pageController => _pageController;
  bool get isPlayerMode => _palyerMode;
  GameState get isGameState => _gameState.value.value;

  var _sizeQuestText = Rx<double?>(null).obs;
  double? textSize() => _sizeQuestText.value.value;

  bool isLoadingQuestion() => _isLoadQuestions.value;
  bool isPlayersNotEmpty() => _players.value.value.length >= 3;
  bool isPlayersEmpty() => _players.value.value.isEmpty;
  bool isPlayer(Player player) => currentPlayer == player;
  int playersLength() => _players.value.value.length;
  List<Player> getPlayer() => _players.value.value;
  Player getPlayerByIndex(int index) => _players.value.value[index];

  void _loadQuestions() async {
    _isLoadQuestions.value = true;
    String response = await rootBundle.loadString('assets/questions/data.txt');

    Iterable<String> list = LineSplitter.split(response);
    for (var element in list) {
      _questions.add(element);
    }
    _isLoadQuestions.value = false;
    nextQuest();
  }

  void initSizeText(double value) {
    _sizeQuestText.value.value ??= value;
  }

  void incSizeText() {
    if (_sizeQuestText.value.value != null) {
      _sizeQuestText.value.value = _sizeQuestText.value.value! + 1;
    }
  }

  void decSizeText() {
    if (_sizeQuestText.value.value != null) {
      _sizeQuestText.value.value = _sizeQuestText.value.value! - 1;
    }
  }

  void playerModeOn() {
    _palyerMode = true;
  }

  void startGame() {
    _gameState.value.value = GameState.play;
    _loadQuestions();
    if (_palyerMode) {
      currentPlayer = _players.value.value[0];
    }
  }

  void endGame() {
    _gameState.value.value = GameState.end;
    _palyerMode = false;
    for (var item in _players.value.value) {
      item.score = 0;
    }
    currentPlayer = null;
  }

  void nextPage() {
    _pageController.animateToPage(1,
        duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
  }

  void addNewPlayer(Player player) {
    _players.value.value.add(player);
    _players.value.refresh();
  }

  void removePlayer(Player player) {
    _players.value.value.remove(player);
    _players.value.refresh();
  }

  void _nextPlayer() {
    if (_palyerMode) {
      int nextPlayer = _players.value.value.indexOf(currentPlayer!) + 1;

      if (nextPlayer > _players.value.value.length - 1) nextPlayer = 0;
      currentPlayer = _players.value.value[nextPlayer];
    }
  }

  void nextQuest() {
    if (_currentQuestIndex.value > -1) {
      _moveQuest();
    }

    if (_questions.length > 1) {
      _genRandQuestNumber(_questions.length - 1);
    } else {
      _resetQuestList();
      _genRandQuestNumber(_questions.length - 1);
    }

    /* if (_currentQuestIndex.value + 1 > _questions.length) {
      _currentQuestIndex.value = 0;
    } else {
      _currentQuestIndex.value++;
    } */
  }

  void _resetQuestList() {
    _questions.addAll(_usedQuestions);
    _usedQuestions.clear();
  }

  void _moveQuest() {
    _usedQuestions.add(_questions[_currentQuestIndex.value]);
    _questions.removeAt(_currentQuestIndex.value);
  }

  void _genRandQuestNumber(int range) {
    _currentQuestIndex.value = Random().nextInt(range);
  }

  String getQuest() {
    return _questions[_currentQuestIndex.value];
  }

  void incScore(Player player) {
    _players.value.value[_players.value.value.indexOf(player)].score += 1;
    _players.value.refresh();
    nextQuest();
    _nextPlayer();
  }
}
