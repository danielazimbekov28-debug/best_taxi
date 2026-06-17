import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taxi_app/feature/history/widgets/trip_history_card.dart';
import '../trips/repozitory/trip_repozitory.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'bloc/history_cubit.dart';
import 'bloc/history_state.dart';


class HistoryScreen extends StatefulWidget {
  // Временно захардкодим тестовый ID, чтобы не привязываться к авторизации
  final String driverId;

  const HistoryScreen({super.key, this.driverId = 'test_driver_777'});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Загружаем историю из Supabase при старте экрана
    _refreshHistory();
  }

  void _refreshHistory() {
    context.read<HistoryCubit>().loadHistory(widget.driverId);
  }

  // Функция для отправки тестовой поездки в Supabase
  void _addTestTrip() async {
    final repo = context.read<TripRepository>();

    // Показываем пользователю, что процесс пошел
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Отправка поездки в Supabase...')),
    );

    try {
      await repo.addTrip(
        driverId: widget.driverId,
        clientId: 'test_client_999',
        pickup: 'Сухум, ул. Аиааира, 15',
        destination: 'Новый Афон, Пещера',
        price: 1200,
        miles: 80,
      );

      // Если добавилось успешно — обновляем список на экране
      _refreshHistory();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Поездка успешно добавлена в базу!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка Supabase: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('История поездок (Тест)'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshHistory,
          )
        ],
      ),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is HistoryError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  state.message,
                  style: AppTextStyles.body.copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state is HistoryLoaded) {
            if (state.trips.isEmpty) {
              return Center(
                child: Text('В базе Supabase пока нет поездок', style: AppTextStyles.body),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.trips.length,
              itemBuilder: (context, index) {
                return TripHistoryCard(trip: state.trips[index]);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      // Кнопка для создания фейковой поездки
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTestTrip,
        backgroundColor: AppColors.primary,
        label: const Text('Симулировать заказ'),
        icon: const Icon(Icons.add_road),
      ),
    );
  }
}