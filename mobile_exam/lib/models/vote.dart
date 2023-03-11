import 'package:freezed_annotation/freezed_annotation.dart';
part 'vote.freezed.dart';
part 'vote.g.dart';

@freezed
class Vote with _$Vote {
  const factory Vote({
    final String? id,
    final bool? like,
  }) = _Vote;

  factory Vote.fromJson(Map<String, dynamic> json) => _$VoteFromJson(json);
}
