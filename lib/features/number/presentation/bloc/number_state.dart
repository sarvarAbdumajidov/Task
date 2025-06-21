import 'package:equatable/equatable.dart';
import 'package:interesting_number/features/number/data/models/number_model.dart';

abstract class NumberState extends Equatable {
  const NumberState();

  @override
  List<Object?> get props => [];
}

class NumberInitial extends NumberState {}

class NumberLoading extends NumberState {}

class NumberLoaded extends NumberState {
  final Number number;

  const NumberLoaded(this.number);

  @override
  List<Object?> get props => [number];
}

class NumberError extends NumberState {
  final String message;

  const NumberError(this.message);

  @override
  List<Object?> get props => [message];
}
