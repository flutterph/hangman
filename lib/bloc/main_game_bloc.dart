import 'dart:math';

import 'package:random_words/random_words.dart';
import "package:rxdart/rxdart.dart";
import 'package:hangman/bloc/bloc_base.dart';

class MainGameBloc implements BlocBase {
  final BehaviorSubject<List<String>> _selectedLettersSubject =
      new BehaviorSubject<List<String>>();
  final BehaviorSubject<List<String>> _randomWordSubject =
      new BehaviorSubject<List<String>>();

  Stream<List<String>> get selectedLettersStream =>
      _selectedLettersSubject.stream;
  Stream<List<String>> get randomWordStream => _randomWordSubject.stream;

  Stream get gameRoundStream => Observable.combineLatestList([
        randomWordStream,
        selectedLettersStream,
      ]);

  void randomizeWord() {
    String randomWord = '';

    if (Random().nextInt(1) == 0) {
      generateNoun().take(1).forEach((n) {
        randomWord = n.asString;
      });
    } else {
      generateAdjective().take(1).forEach((a) {
        randomWord = a.asString;
      });
    }

    _randomWordSubject.sink.add(randomWord.toUpperCase().split(''));
    _selectedLettersSubject.sink.add([]);
  }

  void selectLetter(String letter) {
    List<String> currentLetters = _selectedLettersSubject.value ?? [];

    currentLetters.add(letter.toUpperCase());

    _selectedLettersSubject.sink.add(currentLetters);
  }

  @override
  void dispose() {
    _selectedLettersSubject.close();
    _randomWordSubject.close();
  }
}
