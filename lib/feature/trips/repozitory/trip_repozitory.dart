import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/trip_models.dart';

class TripRepository {
  final SupabaseClient _supabase;

  TripRepository(this._supabase);

  // 1. Получение истории ВОДИТЕЛЯ из Supabase
  Future<List<TripModel>> getDriverTrips(String driverId) async {
    // Делаем запрос к таблице 'trips'
    final response = await _supabase
        .from('trips')
        .select()
        .eq('driver_id', driverId) // Берем только поездки этого водителя
        .order('created_at', ascending: false); // Новые поездки сверху

    // Превращаем ответ от базы (JSON) в список наших моделей
    return response.map((json) => TripModel.fromJson(json)).toList();
  }

  // 2. Добавление новой поездки (для сокомандников)
  Future<void> addTrip({
    required String driverId,
    required String clientId, // Добавили клиента, как договаривались
    required String pickup,
    required String destination,
    required int price,
    required int miles,
  }) async {
    await _supabase.from('trips').insert({
      'driver_id': driverId,
      'client_id': clientId,
      'pickup_address': pickup,
      'destination_address': destination,
      'price': price,
      'earned_miles': miles,
      'status': 'completed',
    });
  }
}