import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

// Модель для чипов и мест (если она не импортирована из order_models)
class PlaceChipData {
  final IconData icon;
  final String title;
  const PlaceChipData(this.icon, this.title);
}

class IdlePanelWidget extends StatelessWidget {
  final VoidCallback onSearchTap;
  final Function(dynamic) onPlaceTap;
  final List<dynamic> recentPlaces; // Передаем список недавних мест

  const IdlePanelWidget({
    super.key,
    required this.onSearchTap,
    required this.onPlaceTap,
    required this.recentPlaces,
  });

  static const _chips = [
    PlaceChipData(Icons.home_rounded, 'Дом'),
    PlaceChipData(Icons.work_rounded, 'Офис'),
    PlaceChipData(Icons.apartment_rounded, 'Квартира'),
    PlaceChipData(Icons.favorite_rounded, 'Мамин дом'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Куда едем?', style: AppTextStyles.h1),
        const SizedBox(height: 16),

        // Фейковое поле поиска (кнопка)
        GestureDetector(
          onTap: onSearchTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                const SizedBox(width: 12),
                Text('Поиск адреса', style: AppTextStyles.bodySecondary),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Горизонтальные чипы быстрых адресов
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _chips.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (_, i) => GestureDetector(
              onTap: () => onPlaceTap(recentPlaces[i % recentPlaces.length]), // Демо-привязка
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Icon(_chips[i].icon, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(_chips[i].title, style: AppTextStyles.body),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(color: AppColors.divider),

        // Список недавних поездок
        if (recentPlaces.isNotEmpty) ...[
          _buildRecentRow(recentPlaces[0]),
          if (recentPlaces.length > 1) _buildRecentRow(recentPlaces[1]),
        ],
      ],
    );
  }

  Widget _buildRecentRow(dynamic place) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.history_rounded, color: AppColors.textSecondary),
      title: Text(place.title ?? '', style: AppTextStyles.body),
      subtitle: Text(place.subtitle ?? '', style: AppTextStyles.bodySecondary),
      onTap: () => onPlaceTap(place),
    );
  }
}