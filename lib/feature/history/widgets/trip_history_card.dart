import 'package:flutter/material.dart';

import '../../../core/models/trip_models.dart';


class TripHistoryCard extends StatelessWidget {
  final TripModel trip;

  const TripHistoryCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    // Человеческий формат даты без сторонних библиотек
    final dateStr = "${trip.createdAt.day}.${trip.createdAt.month}.${trip.createdAt.year}";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Верхняя строчка: Дата и Цена
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateStr,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
              Text(
                '${trip.price} ₽',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Точка А (Откуда)
          Row(
            children: [
              const Icon(Icons.circle, size: 10, color: Colors.green),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  trip.pickupAddress,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // Вертикальная линия-разделитель между точками
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 4, bottom: 4),
            child: Container(
              width: 2,
              height: 15,
              color: Colors.grey.shade300,
            ),
          ),

          // Точка Б (Куда)
          Row(
            children: [
              const Icon(Icons.location_on_rounded, size: 14, color: Colors.red),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  trip.destinationAddress,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // Показываем блок бонусов, если они есть
          if (trip.earnedMiles > 0) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1, color: Color(0xFFEEEEEE)), // Тут была ошибка, теперь здесь обычный серый цвет
            ),
            Row(
              children: [
                const Icon(Icons.star_rounded, size: 16, color: Colors.orange),
                const SizedBox(width: 6),
                Text(
                  '+${trip.earnedMiles} миль начислено',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}