import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interesting_number/features/number/data/repositories/number_fact_repository.dart';
import 'package:interesting_number/features/number/presentation/bloc/number_event.dart';
import 'package:interesting_number/features/number/presentation/bloc/number_state.dart';

class NumberBloc extends Bloc<NumberEvent, NumberState> {
  final NumberFactRepository repository;

  NumberBloc({required this.repository}) : super(NumberInitial()) {
    on<GetNumberFact>(_onGetNumberFact);
  }

  Future<void> _onGetNumberFact(GetNumberFact event, Emitter<NumberState> emit) async {
    emit(NumberLoading());
    try {
      final result = await repository.fetchNumberFact(
        number: event.number,
        type: event.type,
        isRandom: event.isRandom,
        month: event.month,
        day: event.day,
      );
      emit(NumberLoaded(result));
    } catch (e) {
      emit(NumberError('NumberError: ${e.toString()}'));
    }
  }
}
