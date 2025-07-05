import 'package:project_cipher/utils/price_calculator.dart';

import '../utils/model.dart';

class Wood extends Model {
  String name;
  double pricePerUnit;
  double discount;

  Wood({
    super.id,
    required this.name,
    required this.pricePerUnit,
    required this.discount,
    super.createdAt,
    super.updatedAt,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price_per_unit': pricePerUnit,
      'discount': discount,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  Wood fromJson(Map<String, dynamic> json) {
    return Wood(
      id: json['id'],
      name: json['name'],
      pricePerUnit: (json['price_per_unit'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  static Wood fromDoc(id, data) {
    return Wood(
        id: id,
        name: data['name'],
        pricePerUnit: (data['price_per_unit'] ?? 0).toDouble(),
        discount: (data['discount'] ?? 0).toDouble(),
        createdAt: data['created_at'],
        updatedAt: data['updated_at']);
  }

  double price({required double volume}) =>
      PriceCalculator.price(volume: volume, price: pricePerUnit);

  @override
  String get collectionName => "woods";
}
