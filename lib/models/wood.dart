import '../utils/model.dart';

class Wood extends Model {
  String name;
  double pricePerInch;
  double discount;

  Wood({
    super.id,
    required this.name,
    required this.pricePerInch,
    required this.discount,
    super.createdAt,
    super.updatedAt,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price_per_inch': pricePerInch,
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
      pricePerInch: (json['price_per_inch'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  static Wood fromDoc(id, data) {
    return Wood(
        id: id,
        name: data['name'],
        pricePerInch: (data['price_per_inch'] ?? 0).toDouble(),
        discount: (data['discount'] ?? 0).toDouble(),
        createdAt: data['created_at'],
        updatedAt: data['updated_at']);
  }

  @override
  String get collectionName => "woods";
}
