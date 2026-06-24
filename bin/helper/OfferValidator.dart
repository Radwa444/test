import '../model/OfferAssembly.dart';

class OfferValidator {
  bool isValid(
      List<OfferAssembly> buyRules,
      Map<String, double> cartItems,
      ) {
    return buyRules.every((rule) {
      final key = '${rule.productID}_${rule.package}';
      final cartQty = cartItems[key] ?? 0;
      return cartQty >= (rule.qty ?? 0);
    });
  }
}