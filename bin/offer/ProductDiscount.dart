import '../model/AppliedOffer.dart';
import '../model/Customer.dart';
import '../model/DiscountByType.dart';
import '../model/DiscountType.dart';
import '../model/InvoiceItem.dart';
import '../model/Offer.dart';
import '../model/OfferAssembly.dart';
import '../model/ProductDiscountModel.dart';
import '../test.dart';
import 'OfferAbstract.dart';

class ProductDiscount extends OfferAbstract<ProductDiscountModel> {
  Map<String, DiscountByType> cartRules = {};
  Map<String, double> cartItems = {};

  @override
  AppliedOffer Apply(Offer currentOffer) {
    // TODO: implement Apply
    throw UnimplementedError();
  }

  @override
  bool ValidateOffer(
    Offer offer,
    List<OfferAssembly> rules,
    ProductDiscountModel model,
  ) {
    cartRules.clear();
    cartItems.clear();
    return (offer.offerType == OfferType.productDiscount.value&&validateCondition(model.items, rules));
  }

  @override
  bool isApplied(List<InvoiceItem> items, List<OfferAssembly> rules) {
    // TODO: implement isApplied
    throw UnimplementedError();
  }

  bool validateCondition(List<InvoiceItem> items, List<OfferAssembly> rules) {
    if (items.isEmpty || rules.isEmpty) return false;
    extractDiscountConditions(rules);
    getEligibleItems(items);
    if (cartRules.isEmpty || cartItems.isEmpty)
      return false;
    else
      return true;
  }

  void extractDiscountConditions(List<OfferAssembly> rules) {
    for (var rule in rules) {
      final key = '${rule.productID}_${rule.package}';
      if (rule.value > 0) {
        cartRules[key] = DiscountByType(
          value: rule.value,
          discountType: DiscountType.amount,
        );
      } else {
        if (rule.pecentage > 0) {
          cartRules[key] = DiscountByType(
            value: rule.pecentage,
            discountType: DiscountType.percentage,
          );
        }
      }
    }
  }

  void getEligibleItems(List<InvoiceItem> items) {
    for (var item in items) {
      final key = '${item.productId}_${item.packageId}';
      cartItems[key] = (cartItems[key] ?? 0) + (item.lineTotal ?? 0);
    }
    cartItems.removeWhere((key, v) => !cartRules.containsKey(key));
  }
}
