import 'package:equatable/equatable.dart';
import '../../../../core/utils/enums.dart';

abstract class NumberEvent extends Equatable {
  const NumberEvent();
}

class GetNumberFact extends NumberEvent {
  final int? number;
  final Type type;
  final bool isRandom;
  final int? month;
  final int? day;

  const GetNumberFact({
    this.number,
    required this.type,
    this.isRandom = false,
    this.month,
    this.day,
  });

  @override
  List<Object?> get props => [number, type, isRandom, month, day];
}
