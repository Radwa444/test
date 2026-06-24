import '../model/OfferAssembly.dart';

class OfferCalculator {
  int calculateApplyCount(
      List<OfferAssembly> buyRules,
      Map<String, double> cartItems,
      ) {
    int minTimes = double.maxFinite.toInt();

    for (final rule in buyRules) {
      final key = '${rule.productID}_${rule.package}';
      final requiredQty = rule.qty ?? 0;
      final cartQty = cartItems[key] ?? 0;

      if (requiredQty <= 0) continue;

      final times = (cartQty ~/ requiredQty);

      if (times < minTimes) {
        minTimes = times;
      }
    }

    return minTimes == double.maxFinite.toInt() ? 0 : minTimes;
  }
}