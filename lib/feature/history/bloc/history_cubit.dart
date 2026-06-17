import 'package:flutter_bloc/flutter_bloc.dart';

import '../../trips/repozitory/trip_repozitory.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final TripRepository _repository;

  HistoryCubit(this._repository) : super(HistoryInitial());

  Future<void> loadHistory(String driverId) async {
    emit(HistoryLoading()); // Показываем крутилку загрузки

    try {
      // Идем в наш репозиторий за данными
      final trips = await _repository.getDriverTrips(driverId);

      // Если все ок, отдаем список на экран
      emit(HistoryLoaded(trips));
    } catch (e) {
      // Если ошибка (например, нет интернета), выдаем ошибку
      emit(HistoryError('Ошибка загрузки истории: $e'));
    }
  }
}