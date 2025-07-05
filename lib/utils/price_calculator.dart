class PriceCalculator {
  static double price({required double volume, required double price, double discount = 0}){
    double discountFactor = 1 - (discount / 100);
    return volume * price * discountFactor;
  }
}