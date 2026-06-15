import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_button_widget.dart';

class RatingPanelWidget extends StatefulWidget {
  final int price;
  final Function(int rating, String comment) onSubmit;

  const RatingPanelWidget({
    super.key,
    required this.price,
    required this.onSubmit,
  });

  @override
  State<RatingPanelWidget> createState() => _RatingPanelWidgetState();
}

class _RatingPanelWidgetState extends State<RatingPanelWidget> {
  int _stars = 5;
  final _commentCtrl = TextEditingController();

  final List<String> _tags = const [
    'Чисто',
    'Вежливый водитель',
    'Быстро доехали',
    'Аккуратная езда',
  ];

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(child: Text('Вы приехали', style: AppTextStyles.h2)),
        const SizedBox(height: 4),
        Center(
          child: Text('Поездка завершена · ${widget.price} ₽', style: AppTextStyles.bodySecondary),
        ),
        const SizedBox(height: 16),
        Center(child: Text('Оцените поездку', style: AppTextStyles.title)),
        const SizedBox(height: 10),

        // Звезды оценки
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            final filled = i < _stars;
            return GestureDetector(
              onTap: () => setState(() => _stars = i + 1),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  filled ? Icons.star_rounded : Icons.star_outline_rounded,
                  size: 40,
                  color: filled ? AppColors.warning : AppColors.border,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 18),

        // Быстрые теги
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _tags.map((tag) {
            return GestureDetector(
              onTap: () {
                final currentText = _commentCtrl.text.trim();
                setState(() {
                  _commentCtrl.text = currentText.isEmpty ? tag : '$currentText, $tag';
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(tag, style: AppTextStyles.bodySecondary),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _commentCtrl,
          minLines: 2,
          maxLines: 4,
          decoration: const InputDecoration(hintText: 'Комментарий (необязательно)'),
        ),
        const SizedBox(height: 16),
        AppButton(
          label: 'Готово',
          onPressed: () => widget.onSubmit(_stars, _commentCtrl.text.trim()),
        ),
      ],
    );
  }
}