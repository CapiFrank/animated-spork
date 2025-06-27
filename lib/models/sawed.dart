import '../utils/model.dart';

class Sawed extends Model {
String customerId;
String woodId;

  Sawed(
      {super.id,
      required this.customerId,
      required this.woodId,
      super.createdAt,
      super.updatedAt});

  @override
  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'wood_id': woodId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  Sawed fromJson(Map<String, dynamic> json) {
    return Sawed(
        customerId: json['customer_id'],
        woodId: json['wood_id'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }

  static Sawed fromDoc(id, data) {
    return Sawed(
        id: id,
        customerId: data['customer_id'],
        woodId: data['wood_id'],
        createdAt: data['created_at'],
        updatedAt: data['updated_at']);
  }

  @override
  String get collectionName => "sawed";
}
