import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../bloc/driver_cubit.dart';
 // Укажи правильный путь к DriverOrder

class EarningsBarWidget extends StatelessWidget {
  final int earnings;
  final int rides;
  const EarningsBarWidget({super.key, required this.earnings, required this.rides});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 14)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _item(Icons.account_balance_wallet_rounded, '$earnings ₽', AppColors.primary),
          _dot(),
          _item(Icons.local_taxi_rounded, '$rides', AppColors.textSecondary),
          _dot(),
          _item(Icons.star_rounded, '5.0', AppColors.warning),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 5),
        Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _dot() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 12),
    width: 3,
    height: 3,
    decoration: const BoxDecoration(color: AppColors.textHint, shape: BoxShape.circle),
  );
}

class ClientRowWidget extends StatelessWidget {
  final DriverOrder order;
  const ClientRowWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primaryLight,
          child: Icon(Icons.person_rounded, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(order.clientName, style: AppTextStyles.title),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.star_rounded, size: 15, color: AppColors.warning),
                  const SizedBox(width: 4),
                  Text('${order.clientRating}', style: AppTextStyles.bodySecondary),
                ],
              ),
            ],
          ),
        ),
        Text('${order.price} ₽', style: AppTextStyles.title),
      ],
    );
  }
}

class AddrRowWidget extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  const AddrRowWidget({super.key, required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

class BadgeWidget extends StatelessWidget {
  final String text;
  final Color color;
  const BadgeWidget({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Text(text,
          style: AppTextStyles.caption.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
    );
  }
}

class PulseDotWidget extends StatefulWidget {
  const PulseDotWidget({super.key});
  @override
  State<PulseDotWidget> createState() => _PulseDotWidgetState();
}

class _PulseDotWidgetState extends State<PulseDotWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
  }
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.35, end: 1.0).animate(_c),
      child: Container(
        width: 12, height: 12,
        decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
      ),
    );
  }
}

class DriverSheetContainer extends StatelessWidget {
  final Widget child;
  const DriverSheetContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 28)],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44, height: 5,
                decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(3)),
              ),
              const SizedBox(height: 16),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.topCenter,
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}