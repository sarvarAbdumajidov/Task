import 'package:hive/hive.dart';

part 'number_model.g.dart';

@HiveType(typeId: 0)
class Number extends HiveObject {
  @HiveField(0)
  final String text;

  @HiveField(1)
  final int? year;

  @HiveField(2)
  final int number;

  @HiveField(3)
  final bool found;

  @HiveField(4)
  final String type;

  Number({
    required this.text,
    this.year,
    required this.number,
    required this.found,
    required this.type,
  });

  factory Number.fromJson(Map<String, dynamic> json) {
    return Number(
      text: json['text'],
      number: json['number'],
      found: json['found'],
      type: json['type'],
      year: json.containsKey('year') ? json['year'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'year': year, 'number': number, 'found': found, 'type': type};
  }
}
