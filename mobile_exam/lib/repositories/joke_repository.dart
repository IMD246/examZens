import 'package:mobile_exam/models/joke.dart';
import 'package:flutter/services.dart' as root;
import 'dart:convert';

class JokeRepository {
  Future<List<Joke>> getAllJoke() async {
    try {
      final jsonData = await root.rootBundle.loadString(
        "jsonFile/data/jokes.json",
      );

      final list = jsonDecode(jsonData) as List<dynamic>;

      return list.map((e) => Joke.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
