import 'package:project_cipher/models/device.dart';
import 'package:project_cipher/utils/auth_global.dart';

class VolumeCalculator {
  static double calculateRoundLogVolume({
    required double circumference,
    required double length,
  }) {
    Device device = auth().device!;
    if (device.useInternationalSystem) {
      double cMeters = circumference * 0.0254;
      double lMeters = length * 0.84;
      return (cMeters / 4) * (cMeters / 4) * (lMeters / 4);
    } else {
      return (circumference / 4) * (circumference / 4) * (length / 4);
    }
  }

  static double calculateSquareLogVolume({
    required double thickness,
    required double width,
    required double length,
  }) {
    Device device = auth().device!;
    if (device.useInternationalSystem) {
      double thicknessMeters = thickness * 0.0254;
      double widthMeters = width * 0.0254;
      double lengthMeters = length * 0.84;
      return (thicknessMeters * widthMeters * lengthMeters) / 4;
    } else {
      return (thickness * width * length) / 4;
    }
  }
}
