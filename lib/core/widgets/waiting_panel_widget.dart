import 'dart:async';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class WaitingPanelWidget extends StatefulWidget {
  final VoidCallback onTripStart;
  final VoidCallback onCancel;
  final VoidCallback onCallTap;
  final VoidCallback onChatTap;
  final String driverName;
  final String driverCar;
  final String driverPlate;

  const WaitingPanelWidget({
    super.key,
    required this.onTripStart,
    required this.onCancel,
    required this.onCallTap,
    required this.onChatTap,
    required this.driverName,
    required this.driverCar,
    required this.driverPlate,
  });

  @override
  State<WaitingPanelWidget> createState() => _WaitingPanelWidgetState();
}

class _WaitingPanelWidgetState extends State<WaitingPanelWidget> {
  Timer? _timer;
  int _elapsed = 0;

  static const _freeSecs = 12;
  static const _tripSecs = 22;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() => _elapsed++);
      if (_elapsed >= _tripSecs) {
        t.cancel();
        widget.onTripStart();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _mmss(int s) {
    final m = s ~/ 60;
    final ss = (s % 60).toString().padLeft(2, '0');
    return '$m:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final paid = _elapsed >= _freeSecs;
    final freeLeft = (_freeSecs - _elapsed).clamp(0, _freeSecs);
    final paidCost = ((_elapsed - _freeSecs).clamp(0, 9999)) * 3;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: paid
                ? AppColors.error.withValues(alpha: 0.10)
                : AppColors.accentLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(paid ? Icons.timer_rounded : Icons.check_circle_rounded,
                  size: 18,
                  color: paid ? AppColors.error : AppColors.primaryDark),
              const SizedBox(width: 8),
              Text(
                paid
                    ? 'Платное ожидание · +$paidCost ₽'
                    : 'Водитель ждёт вас · бесплатно ${_mmss(freeLeft)}',
                style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: paid ? AppColors.error : AppColors.primaryDark),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.primaryLight,
              backgroundImage: const AssetImage('assets/images/driver_placeholder.png'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.driverName, style: AppTextStyles.title),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Image.asset('assets/icons/star_filled.png', width: 14, height: 14),
                      const SizedBox(width: 4),
                      Text('4.9 · ${widget.driverCar}',
                          style: AppTextStyles.bodySecondary),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(widget.driverPlate,
                  style: AppTextStyles.title.copyWith(fontSize: 16)),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.background,
                  foregroundColor: AppColors.accent,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: widget.onCallTap,
                icon: const Icon(Icons.call_rounded, size: 20),
                label: const Text('Позвонить'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.background,
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: widget.onChatTap,
                icon: const Icon(Icons.chat_bubble_rounded, size: 20),
                label: const Text('Чат'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Center(
          child: TextButton(
            onPressed: widget.onCancel,
            child: Text('Отменить поездку',
                style: AppTextStyles.body.copyWith(color: AppColors.error)),
          ),
        ),
      ],
    );
  }
}