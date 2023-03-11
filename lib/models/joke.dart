import 'package:freezed_annotation/freezed_annotation.dart';
part 'joke.freezed.dart';
part 'joke.g.dart';

@freezed
class Joke with _$Joke {
  const factory Joke({
    final String? id,
    final String? content,
  }) = _Joke;

  factory Joke.fromJson(Map<String, dynamic> json) => _$JokeFromJson(json);
}
