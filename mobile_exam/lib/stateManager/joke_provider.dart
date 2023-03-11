import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:mobile_exam/repositories/joke_repository.dart';
import 'package:mobile_exam/services/local_storage.dart';

import '../models/joke.dart';
import '../models/vote.dart';

class JokeProvider extends ChangeNotifier {
  late JokeRepository _jokeRepository;
  late LocalStorage _localStorage;
  late List<Joke> listJokes;
  late List<Vote> listVotes;
  int day = 0;
  int count = 0;
  JokeProvider({required LocalStorage localStorage}) {
    _jokeRepository = JokeRepository();
    _localStorage = localStorage;
  }

  Future<void> initJoke() async {
    if (count == 0) {
      try {
        day = _localStorage.getDay();
        await _localStorage.setDay();
        count++;
        listVotes = _localStorage.getListVotes();

        listJokes = _localStorage.getListJokes();
        if (day != DateTime.now().day) {
          listJokes = await _jokeRepository.getAllJoke();
          await _localStorage.setListJokes(values: listJokes);
          _localStorage.setListVotes(values: []);
          listVotes = _localStorage.getListVotes();
        }
        
        if ((listJokes.isEmpty && listVotes.isEmpty)) {
          listJokes = await _jokeRepository.getAllJoke();
          await _localStorage.setListJokes(values: listJokes);
        }

        if (kDebugMode) {
          print("listJoke:${listJokes.length}");

          print("listVote:${listVotes.length}");
        }
      } catch (e) {
        if (kDebugMode) {
          print("ERROR:$e");
        }
      }
    }
  }

  Future<void> processingGame({required bool value}) async {
    if (listJokes.isNotEmpty) {
      listVotes.add(
        Vote(
          id: listJokes.first.id,
          like: value,
        ),
      );
      await _localStorage.setListVotes(values: listVotes);
      if (listJokes.isNotEmpty) {
        listJokes.removeAt(0);
        await _localStorage.setListJokes(values: listJokes);
      }
      log(
        listJokes.length.toString(),
      );
      notifyListeners();
    }
  }
}
