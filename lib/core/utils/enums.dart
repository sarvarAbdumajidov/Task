enum Type { date, trivia, math }

extension TypeExtension on Type {
  String get name => toString().split('.').last;
}
