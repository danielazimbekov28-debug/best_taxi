import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

// Импорты данных и вынесенных виджетов
import 'loyalty_models.dart';
import 'widgets/loyalty_widgets.dart';

class LoyaltyScreen extends StatefulWidget {
  const LoyaltyScreen({super.key});

  @override
  State<LoyaltyScreen> createState() => _LoyaltyScreenState();
}

class _LoyaltyScreenState extends State<LoyaltyScreen> {
  int _miles = 1250;
  static const _goal = 2000; // мили до следующего уровня (Золото)

  void _redeem(RewardModel r) {
    final messenger = ScaffoldMessenger.of(context);
    if (_miles < r.cost) {
      messenger.showSnackBar(SnackBar(
        content: Text('Не хватает ${r.cost - _miles} миль'),
        backgroundColor: AppColors.error,
      ));
      return;
    }
    setState(() => _miles -= r.cost);
    messenger.showSnackBar(SnackBar(
      content: Text('Списано ${r.cost} миль · ${r.title}'),
      backgroundColor: AppColors.success,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_miles / _goal).clamp(0.0, 1.0);
    final left = (_goal - _miles).clamp(0, _goal);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Мили и бонусы'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          BalanceCardWidget(miles: _miles, progress: progress, milesLeft: left),
          const SizedBox(height: 24),

          Text('Потратить мили', style: AppTextStyles.title),
          const SizedBox(height: 12),
          ...mockRewards.map((r) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: RewardCardWidget(
              reward: r,
              enough: _miles >= r.cost,
              onRedeem: () => _redeem(r),
            ),
          )),
          const SizedBox(height: 14),

          Text('Как копить мили', style: AppTextStyles.title),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                for (var i = 0; i < mockEarnRules.length; i++) ...[
                  if (i > 0) const Divider(height: 1, color: AppColors.divider),
                  EarnRowWidget(
                    icon: mockEarnRules[i].$1,
                    text: mockEarnRules[i].$2,
                    amount: mockEarnRules[i].$3,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text('История', style: AppTextStyles.title),
          const SizedBox(height: 8),
          ...mockHistory.map((t) => HistoryRowWidget(tx: t)),
        ],
      ),
    );
  }
}
