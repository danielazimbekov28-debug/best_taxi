class TripModel {
  final String id;
  final String pickupAddress;
  final String destinationAddress;
  final int price;
  final int earnedMiles;
  final DateTime createdAt;

  TripModel({
    required this.id,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.price,
    required this.earnedMiles,
    required this.createdAt,
  });

  // Парсинг данных из Supabase
  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] as String,
      pickupAddress: json['pickup_address'] as String,
      destinationAddress: json['destination_address'] as String,
      price: json['price'] as int,
      earnedMiles: json['earned_miles'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}