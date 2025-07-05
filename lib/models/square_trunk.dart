import 'package:project_cipher/utils/volume_calculator.dart';

import '../utils/model.dart';

class SquareTrunk extends Model {
  double thickness;
  double width;
  double length;
  double quantity;
  double price;
  double totalPrice;

  SquareTrunk(
      {super.id,
      required this.thickness,
      required this.width,
      required this.length,
      required this.quantity,
      required this.price,
      required this.totalPrice,
      super.createdAt,
      super.updatedAt});

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'thickness': thickness,
      'width': width,
      'length': length,
      'quantity': quantity,
      'price': price,
      'total_price': totalPrice,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  SquareTrunk fromJson(Map<String, dynamic> json) {
    return SquareTrunk(
        id: json['id'],
        thickness: json['thickness'],
        width: json['width'],
        length: json['length'],
        quantity: json['quantity'],
        price: json['price'],
        totalPrice: json['total_price'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }

  static SquareTrunk fromDoc(id, data) {
    return SquareTrunk(
        id: id,
        thickness: data['thickness'],
        width: data['width'],
        length: data['length'],
        quantity: data['quantity'],
        price: data['price'],
        totalPrice: data['total_price'],
        createdAt: data['created_at'],
        updatedAt: data['updated_at']);
  }

  double get volumePerUnit => VolumeCalculator.calculateSquareLogVolume(
      thickness: thickness, width: width, length: length);

  double get totalVolume => volumePerUnit * quantity;

  @override
  String get collectionName => "square_trunks";
}
