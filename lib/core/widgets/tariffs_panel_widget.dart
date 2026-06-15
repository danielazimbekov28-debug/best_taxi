import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_button_widget.dart';

class TariffsPanelWidget extends StatelessWidget {
  final List<dynamic> stops;
  final double totalKm;
  final int totalMin;
  final List<dynamic> tariffs;
  final int selectedTariffIndex;
  final VoidCallback onAddStop;
  final Function(int) onRemoveStop;
  final Function(int) onTariffSelect;
  final VoidCallback onOrderPressed;

  const TariffsPanelWidget({
    super.key,
    required this.stops,
    required this.totalKm,
    required this.totalMin,
    required this.tariffs,
    required this.selectedTariffIndex,
    required this.onAddStop,
    required this.onRemoveStop,
    required this.onTariffSelect,
    required this.onOrderPressed,
  });

  @override
  Widget build(BuildContext context) {
    final currentTariff = tariffs[selectedTariffIndex];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Маршрут (список остановок)
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stops.length,
          itemBuilder: (context, i) {
            return Row(
              children: [
                Icon(
                  i == 0 ? Icons.my_location_rounded : Icons.place_rounded,
                  size: 18,
                  color: i == 0 ? AppColors.primary : AppColors.error,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    stops[i].title,
                    style: AppTextStyles.body,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (i > 0)
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: () => onRemoveStop(i),
                  ),
              ],
            );
          },
        ),
        TextButton.icon(
          onPressed: onAddStop,
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Добавить адрес'),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.route_rounded, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text('≈ $totalKm км · $totalMin мин', style: AppTextStyles.bodySecondary),
          ],
        ),
        const SizedBox(height: 14),

        // Горизонтальная лента тарифов
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: tariffs.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final isSelected = i == selectedTariffIndex;
              return GestureDetector(
                onTap: () => onTariffSelect(i),
                child: Container(
                  width: 110,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryLight : AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/icons/tariff_car.png', width: 48, height: 32), // Ассет вместо иконки
                      const SizedBox(height: 8),
                      Text(tariffs[i].name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                      Text('${tariffs[i].price} ₽', style: AppTextStyles.bodySecondary),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        AppButton(
          label: 'Заказать ${currentTariff.name} · ${currentTariff.price} ₽',
          onPressed: onOrderPressed,
        ),
      ],
    );
  }
}