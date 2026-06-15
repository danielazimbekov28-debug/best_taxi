import 'package:flutter/material.dart';

class RewardModel {
  final IconData icon;
  final String title;
  final int cost;
  const RewardModel(this.icon, this.title, this.cost);
}

class TransactionModel {
  final String title;
  final String when;
  final int amount; // + начисление, − списание
  const TransactionModel(this.title, this.when, this.amount);
}

// Заглушки для дизайна
const mockRewards = <RewardModel>[
  RewardModel(Icons.percent_rounded, 'Скидка 100 ₽', 500),
  RewardModel(Icons.percent_rounded, 'Скидка 250 ₽', 1000),
  RewardModel(Icons.upgrade_rounded, 'Повышение до Комфорт', 800),
  RewardModel(Icons.card_giftcard_rounded, 'Бесплатная поездка', 2000),
];

const mockEarnRules = <(IconData, String, String)>[
  (Icons.directions_car_rounded, 'За каждые 10 ₽ поездки', '+1 миля'),
  (Icons.star_rounded, 'За оценку поездки', '+20 миль'),
  (Icons.group_add_rounded, 'За приглашённого друга', '+500 миль'),
];

const mockHistory = <TransactionModel>[
  TransactionModel('Поездка · Аэропорт Сухум', 'Сегодня', 55),
  TransactionModel('Поездка · Набережная', 'Вчера', 25),
  TransactionModel('Скидка на поезку', '5 июня', -500),
  TransactionModel('Бонус за регистрацию', '1 июня', 1000),
];