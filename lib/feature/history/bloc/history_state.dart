
import '../../../core/models/trip_models.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<TripModel> trips;

  HistoryLoaded(this.trips);
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);
}