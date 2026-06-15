import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button_widget.dart';
import '../bloc/driver_cubit.dart';
 // Укажи правильный путь
import 'driver_shared_ui.dart';

class OfflinePanelWidget extends StatelessWidget {
  final VoidCallback onGoOnline;
  const OfflinePanelWidget({super.key, required this.onGoOnline});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Вы офлайн', style: AppTextStyles.h2),
        const SizedBox(height: 6),
        Text('Выйдите на линию, чтобы получать заказы', style: AppTextStyles.bodySecondary),
        const SizedBox(height: 16),
        AppButton(label: 'Выйти на линию', icon: Icons.power_settings_new_rounded, onPressed: onGoOnline),
      ],
    );
  }
}

class OnlinePanelWidget extends StatelessWidget {
  final VoidCallback onGoOffline;
  const OnlinePanelWidget({super.key, required this.onGoOffline});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PulseDotWidget(),
            const SizedBox(width: 10),
            Text('Вы на линии · ищем заказы…', style: AppTextStyles.title),
          ],
        ),
        const SizedBox(height: 16),
        AppButton(label: 'Завершить смену', outlined: true, onPressed: onGoOffline),
      ],
    );
  }
}

class ToPickupPanelWidget extends StatelessWidget {
  final DriverOrder order;
  final VoidCallback onArrived;
  final VoidCallback onCancel;
  const ToPickupPanelWidget({super.key, required this.order, required this.onArrived, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BadgeWidget(text: 'Забрать клиента', color: AppColors.accentLight),
        const SizedBox(height: 14),
        ClientRowWidget(order: order),
        const SizedBox(height: 12),
        AddrRowWidget(icon: Icons.my_location_rounded, color: AppColors.primary, text: order.pickup),
        const SizedBox(height: 16),
        AppButton(label: 'Я на месте', onPressed: onArrived),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: onCancel,
            child: Text('Отменить', style: AppTextStyles.body.copyWith(color: AppColors.error)),
          ),
        ),
      ],
    );
  }
}

class WaitingPanelWidget extends StatelessWidget {
  final DriverOrder order;
  final VoidCallback onStart;
  final VoidCallback onCancel;
  const WaitingPanelWidget({super.key, required this.order, required this.onStart, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BadgeWidget(text: 'Ожидание клиента', color: AppColors.accentLight),
        const SizedBox(height: 14),
        ClientRowWidget(order: order),
        const SizedBox(height: 12),
        AddrRowWidget(icon: Icons.my_location_rounded, color: AppColors.primary, text: order.pickup),
        const SizedBox(height: 16),
        AppButton(label: 'Начать поездку', icon: Icons.play_arrow_rounded, onPressed: onStart),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: onCancel,
            child: Text('Отменить', style: AppTextStyles.body.copyWith(color: AppColors.error)),
          ),
        ),
      ],
    );
  }
}

class InProgressPanelWidget extends StatelessWidget {
  final DriverOrder order;
  final VoidCallback onComplete;
  const InProgressPanelWidget({super.key, required this.order, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BadgeWidget(text: 'Поездка', color: AppColors.primaryLight),
        const SizedBox(height: 14),
        AddrRowWidget(icon: Icons.place_rounded, color: AppColors.error, text: order.destination),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.route_rounded, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text('≈ ${order.km} км · ${order.min} мин · ${order.price} ₽', style: AppTextStyles.bodySecondary),
          ],
        ),
        const SizedBox(height: 16),
        AppButton(label: 'Завершить поездку', onPressed: onComplete),
      ],
    );
  }
}

class IncomingCardWidget extends StatefulWidget {
  final DriverOrder order;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  const IncomingCardWidget({super.key, required this.order, required this.onAccept, required this.onDecline});

  @override
  State<IncomingCardWidget> createState() => _IncomingCardWidgetState();
}

class _IncomingCardWidgetState extends State<IncomingCardWidget> with SingleTickerProviderStateMixin {
  static const _seconds = 15;
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: _seconds))..forward();
    _c.addStatusListener((s) {
      if (s == AnimationStatus.completed) widget.onDecline();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('${o.price} ₽', style: AppTextStyles.h1),
            const SizedBox(width: 10),
            Expanded(child: Text('≈ ${o.km} км · ${o.min} мин', style: AppTextStyles.bodySecondary)),
            AnimatedBuilder(
              animation: _c,
              builder: (context, _) {
                final left = (_seconds * (1 - _c.value)).ceil();
                return SizedBox(
                  height: 40, width: 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: 1 - _c.value, strokeWidth: 3,
                        backgroundColor: AppColors.border,
                        valueColor: const AlwaysStoppedAnimation(AppColors.accentDark),
                      ),
                      Text('$left', style: AppTextStyles.bodySecondary.copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.alt_route_rounded, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Expanded(child: Text('${o.pickup} → ${o.destination}', style: AppTextStyles.bodySecondary, maxLines: 1, overflow: TextOverflow.ellipsis)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 54,
                child: OutlinedButton(
                  onPressed: widget.onDecline,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Отклонить'),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(flex: 2, child: AppButton(label: 'Принять', onPressed: widget.onAccept)),
          ],
        ),
      ],
    );
  }
}