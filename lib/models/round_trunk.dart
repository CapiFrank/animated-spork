import 'package:project_cipher/utils/volume_calculator.dart';

import '../utils/model.dart';

class RoundTrunk extends Model {
  double circumference;
  double length;
  double price;
  

  RoundTrunk(
      {super.id,
      required this.circumference,
      required this.length,
      required this.price,
      super.createdAt,
      super.updatedAt});

  @override
  Map<String, dynamic> toJson() {
    return {
      'circumference': circumference,
      'length': length,
      'price': price,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  RoundTrunk fromJson(Map<String, dynamic> json) {
    return RoundTrunk(
        id: json['id'],
        circumference: json['circumference'],
        length: json['length'],
        price: json['price'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }

  static RoundTrunk fromDoc(id, data) {
    return RoundTrunk(
        id: id,
        circumference: data['circumference'],
        length: data['length'],
        price: data['price'],
        createdAt: data['created_at'],
        updatedAt: data['updated_at']);
  }

  double get volumePerUnit => VolumeCalculator.calculateRoundLogVolume(
      circumference: circumference, length: length);

  @override
  String get collectionName => "round_trunks";
}
