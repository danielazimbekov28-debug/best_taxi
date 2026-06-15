import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';

// Импорты вынесенных виджетов
import '../driver/bloc/driver_cubit.dart';
import '../driver/widgets/driver_map_widget.dart';
import '../driver/widgets/driver_panels.dart';
import '../driver/widgets/driver_shared_ui.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DriverCubit(),
      child: const _DriverHomeView(),
    );
  }
}

class _DriverHomeView extends StatelessWidget {
  const _DriverHomeView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriverCubit, DriverState>(
      builder: (context, state) {
        final hasOrder = state.stage == DriverStage.incoming ||
            state.stage == DriverStage.toPickup ||
            state.stage == DriverStage.waiting ||
            state.stage == DriverStage.inProgress;

        return Scaffold(
          backgroundColor: AppColors.surface,
          body: Stack(
            children: [
              // Слой 1: Карта
              Positioned.fill(
                child: DriverMapWidget(order: hasOrder ? state.order : null),
              ),

              // Слой 2: Сводка заработка (скрывается, если есть заказ)
              if (!hasOrder)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: EarningsBarWidget(
                        earnings: state.todayEarnings,
                        rides: state.todayRides,
                      ),
                    ),
                  ),
                ),

              // Слой 3: Динамическая панель статуса
              Align(
                alignment: Alignment.bottomCenter,
                child: DriverSheetContainer(
                  child: _buildPanel(context, state),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Диспетчер переключения состояний
  Widget _buildPanel(BuildContext context, DriverState state) {
    final cubit = context.read<DriverCubit>();

    switch (state.stage) {
      case DriverStage.offline:
        return OfflinePanelWidget(onGoOnline: cubit.goOnline);
      case DriverStage.online:
        return OnlinePanelWidget(onGoOffline: cubit.goOffline);
      case DriverStage.incoming:
        return IncomingCardWidget(
          key: ValueKey(state.order),
          order: state.order!,
          onAccept: cubit.accept,
          onDecline: cubit.decline,
        );
      case DriverStage.toPickup:
        return ToPickupPanelWidget(
          order: state.order!,
          onArrived: cubit.arrived,
          onCancel: cubit.decline,
        );
      case DriverStage.waiting:
        return WaitingPanelWidget(
          order: state.order!,
          onStart: cubit.startTrip,
          onCancel: cubit.decline,
        );
      case DriverStage.inProgress:
        return InProgressPanelWidget(
          order: state.order!,
          onComplete: cubit.complete,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
