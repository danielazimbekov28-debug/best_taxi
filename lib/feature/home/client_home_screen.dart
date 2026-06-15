import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

// Глобальные виджеты из core (убедись, что файлы созданы по этим путям)
import '../../core/widgets/map_view_widget.dart';
import '../../core/widgets/idle_panel_widget.dart';
import '../../core/widgets/tariffs_panel_widget.dart';
import '../../core/widgets/waiting_panel_widget.dart';
import '../../core/widgets/rating_panel_widget.dart';
import '../../core/theme/app_colors.dart';

// Импорты твоих реальных файлов Блока
import '../order/bloc/order_cubit.dart';
import '../order/order_models.dart';

// === ЛОКАЛЬНЫЕ ПОМОЩНИКИ (Чтобы не было ошибок импорта) ===
const _driverName = 'Астамур';
const _driverPhone = '+7 940 123 45 67';
const _driverCar = 'Toyota Camry, белый';
const _driverPlate = 'A 123 AB';
const _defaultTo = LatLng(43.0145, 41.0440);

// Фейковая функция для звонка, чтобы не ругался на отсутствие launchers.dart
void _openWhatsAppFake(String phone) {
  debugPrint('Звонок/Чат через WhatsApp на номер: $phone');
}

// Перекачиваем локальные демо-модели (если в твоем order_models.dart они называются иначе)
class LocalTariff {
  final String name;
  final int price;
  const LocalTariff({required this.name, required this.price});
}

class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderCubit(),
      child: const _ClientHomeView(),
    );
  }
}

class _ClientHomeView extends StatefulWidget {
  const _ClientHomeView();

  @override
  State<_ClientHomeView> createState() => _ClientHomeViewState();
}

class _ClientHomeViewState extends State<_ClientHomeView> {
  OrderCubit get _cubit => context.read<OrderCubit>();

  // Определение фазы анимации машинки на карте
  CarPhase _phaseFor(dynamic stage) {
    // ВНИМАНИЕ: Если у тебя в OrderStage статусы называются по-другому, поменяй их здесь
    switch (stage) {
      case OrderStage.driverFound: return CarPhase.approaching;
      case OrderStage.driverWaiting: return CarPhase.waiting;
      case OrderStage.riding: return CarPhase.riding;
      case OrderStage.rating: return CarPhase.arrived;
      default: return CarPhase.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        final stage = state.stage;

        // ВНИМАНИЕ: Проверь, как в твоем OrderState называются эти переменные!
        // Если у тебя нет state.mapPick или state.hasStops, замени на свои переменные/геттеры
        final isMapPick = stage == OrderStage.mapPick;

        // Безопасная проверка флага наличия остановок (если в стейте нет hasStops, временно поставь true)
        final bool hasRoute = true;

        // Координаты (если в стейте нет mapPoint, используй дефолтную точку)
        final LatLng? routeTo = _defaultTo;
        final phase = _phaseFor(stage);

        return Scaffold(
          backgroundColor: AppColors.surface,
          body: Stack(
            children: [
              // 1. Карта на весь экран
              Positioned.fill(
                child: MapViewWidget(
                  showRoute: hasRoute,
                  phase: phase,
                  routeTo: routeTo,
                  onTap: isMapPick ? (point) {
                    // _cubit.setMapPoint(point); // Раскомментируй, если метод есть в Кубите
                  } : null,
                ),
              ),

              // 2. Панель управления (Шторка)
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildPanel(state),
              ),
            ],
          ),
        );
      },
    );
  }

  // Диспетчер переключения шторок
  Widget _buildPanel(OrderState state) {
    Widget wrapSheet(Widget child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: child,
        ),
      );
    }

    // Демо-данные для тарифов, чтобы не зависеть от твоего бэкенда при верстке интерфейса
    final dummyTariffs = [
      const LocalTariff(name: 'Эконом', price: 150),
      const LocalTariff(name: 'Комфорт', price: 250),
    ];

    // ВНИМАНИЕ: Сверяй кейсы (state.stage) со своими названиями из OrderStage
    switch (state.stage) {
      case OrderStage.idle:
        return wrapSheet(
          IdlePanelWidget(
            onSearchTap: () {
              // Логика нажатия на поиск адреса
            },
            onPlaceTap: (place) {
              // Логика выбора быстрого адреса
            },
            recentPlaces: const [], // Передаем пустой список, если пока нет истории
          ),
        );

      case OrderStage.tariffs:
        return wrapSheet(
          TariffsPanelWidget(
            stops: const [], // Вставь сюда список адресов, например: state.stops
            totalKm: 0.0,    // Вставь сюда километраж, например: state.totalKm
            totalMin: 0,     // Вставь сюда время, например: state.totalMin
            tariffs: dummyTariffs,
            selectedTariffIndex: 0, // Например: state.selectedTariff
            onAddStop: () {
              // _cubit.addStop(); // Вызывай свой метод кубита добавления точки
            },
            onRemoveStop: (index) {
              // _cubit.removeStop(index); // Вызывай свой метод кубита удаления
            },
            onTariffSelect: (index) {
              // _cubit.selectTariff(index); // Вызывай свой метод кубита смены тарифа
            },
            onOrderPressed: () {
              // _cubit.confirmOrder(); // Вызывай свой метод кубита создания заказа
            },
          ),
        );

      case OrderStage.driverWaiting:
        return wrapSheet(
          WaitingPanelWidget(
            onTripStart: () {
              // _cubit.startTrip(); // Метод начала поездки
            },
            onCancel: () {
              // _cubit.cancelOrder(); // Метод отмены поездки
            },
            onCallTap: () => _openWhatsAppFake(_driverPhone),
            onChatTap: () {
              // Логика перехода на ChatScreen
            },
            driverName: _driverName,
            driverCar: _driverCar,
            driverPlate: _driverPlate,
          ),
        );

      case OrderStage.rating:
        return wrapSheet(
          RatingPanelWidget(
            price: dummyTariffs[0].price,
            onSubmit: (rating, comment) {
              // _cubit.sendReview(rating, comment); // Метод отправки оценки
            },
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}