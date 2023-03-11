import 'dart:convert';

import 'package:mobile_exam/models/vote.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/joke.dart';

class LocalStorage {
  final String _votesKey = "votes";
  final String _jokesKey = "jokes";
  final String _dayKey = "day";
  late SharedPreferences _sharedPreferences;
  LocalStorage({required SharedPreferences sharedPref}) {
    _sharedPreferences = sharedPref;
  }

  List<Vote> getListVotes() {
    final data = _sharedPreferences.getStringList(_votesKey) ?? [];
    if (data.isNotEmpty) {
      return data
          .map(
            (e) => Vote.fromJson(
              jsonDecode(e),
            ),
          )
          .toList();
    }
    return [];
  }

  Future<void> setListVotes({required List<Vote> values}) async {
    await _sharedPreferences.setStringList(
      _votesKey,
      values.map((e) => jsonEncode(e)).toList(),
    );
  }

  List<Joke> getListJokes() {
    final data = _sharedPreferences.getStringList(_jokesKey) ?? [];
    if (data.isNotEmpty) {
      return data
          .map(
            (e) => Joke.fromJson(
              jsonDecode(e),
            ),
          )
          .toList();
    }
    return [];
  }

  Future<void> setListJokes({required List<Joke> values}) async {
    await _sharedPreferences.setStringList(
      _jokesKey,
      values.map((e) => jsonEncode(e)).toList(),
    );
  }

  Future<void> setDay() async {
    await _sharedPreferences.setInt(
      _dayKey,
      DateTime.now().day,
    );
  }
  int getDay() {
return _sharedPreferences.getInt(
      _dayKey,
    ) ?? 0;
  }
}
