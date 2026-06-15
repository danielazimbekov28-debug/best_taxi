import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../loyalty_models.dart';

class BalanceCardWidget extends StatelessWidget {
  final int miles;
  final double progress;
  final int milesLeft;
  const BalanceCardWidget({
    super.key,
    required this.miles,
    required this.progress,
    required this.milesLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Ваши мили', style: AppTextStyles.body.copyWith(color: Colors.white70)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.workspace_premium_rounded, size: 16, color: AppColors.primaryDark),
                    const SizedBox(width: 4),
                    Text('Серебро',
                        style: AppTextStyles.caption.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('$miles',
                  style: const TextStyle(
                      color: AppColors.accent, fontSize: 40, fontWeight: FontWeight.w800)),
              const SizedBox(width: 6),
              Text('миль', style: AppTextStyles.body.copyWith(color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            milesLeft == 0
                ? 'Уровень Золото достигнут!'
                : 'До уровня Золото осталось $milesLeft миль',
            style: AppTextStyles.caption.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class RewardCardWidget extends StatelessWidget {
  final RewardModel reward;
  final bool enough;
  final VoidCallback onRedeem;
  const RewardCardWidget({
    super.key,
    required this.reward,
    required this.enough,
    required this.onRedeem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(reward.icon, color: AppColors.primaryDark, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reward.title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text('${reward.cost} миль', style: AppTextStyles.caption),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onRedeem,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: enough ? AppColors.accent : AppColors.disabled,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text('Обменять',
                  style: AppTextStyles.bodySecondary.copyWith(
                      color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

class EarnRowWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final String amount;
  const EarnRowWidget({super.key, required this.icon, required this.text, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.primary),
          const SizedBox(width: 14),
          Expanded(child: Text(text, style: AppTextStyles.body)),
          Text(amount,
              style: AppTextStyles.body.copyWith(
                  color: AppColors.success, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class HistoryRowWidget extends StatelessWidget {
  final TransactionModel tx;
  const HistoryRowWidget({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {
    final positive = tx.amount > 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: (positive ? AppColors.success : AppColors.error).withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              positive ? Icons.add_rounded : Icons.remove_rounded,
              color: positive ? AppColors.success : AppColors.error,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.title,
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(tx.when, style: AppTextStyles.caption),
              ],
            ),
          ),
          Text(
            '${positive ? '+' : ''}${tx.amount}',
            style: AppTextStyles.title.copyWith(
              fontSize: 16,
              color: positive ? AppColors.success : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}