import 'dart:math';

import '../model/AppliedItemDiscount.dart';
import '../model/AppliedOffer.dart';
import '../model/DiscountByType.dart';
import '../model/DiscountType.dart';
import '../model/InvoiceItem.dart';
import '../model/Offer.dart';
import '../model/OfferAssembly.dart';
import '../model/ProductDiscountModel.dart';
import '../test.dart';
import 'OfferAbstract.dart';

class CustomerProduct extends OfferAbstract<ProductDiscountModel> {
  Map<String, DiscountByType> cartRules = {};
  Map<String, InvoiceItem> cartItems = {};
  List<AppliedItemDiscount> appliedItemDiscount = [];
  @override
  AppliedOffer Apply(Offer currentOffer) {
    calculateDiscount();
    if (appliedItemDiscount.isNotEmpty) {
      return AppliedOffer(
        offerId: currentOffer.id ?? 0,
        name: '',
        discounts: appliedItemDiscount,
      );
    } else
      return AppliedOffer(offerId: 0, name: '');
  }

  @override
  bool ValidateOffer(
    Offer offer,
    List<OfferAssembly> rules,
    ProductDiscountModel model,
  ) {
    cartRules.clear();
    cartItems.clear();
    appliedItemDiscount.clear();
    return (offer.offerType == OfferType.customer &&
        buildDiscountContext(model.items, rules, model.customerId));
  }

  @override
  bool isApplied(List<InvoiceItem> items, List<OfferAssembly> rules) {
    // TODO: implement isApplied
    throw UnimplementedError();
  }

  bool buildDiscountContext(
    List<InvoiceItem> items,
    List<OfferAssembly> rules,
    int customer,
  ) {
    if (items.isEmpty || rules.isEmpty) return false;
    extractDiscountConditions(rules,customer);
    buildEligibleItemsMap(items);
    return (cartItems.isNotEmpty && cartRules.isNotEmpty);
  }

  void extractDiscountConditions(List<OfferAssembly> rules,int customer) {
    for (var rule in rules) {
      if(rule.customerID==customer){
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
  }

  void buildEligibleItemsMap(List<InvoiceItem> items) {
    for (var item in items) {
      final key = '${item.productId}_${item.packageId}';
      cartItems[key] = item;
    }
    cartItems.removeWhere((key, v) => !cartRules.containsKey(key));
  }

  void calculateDiscount() {
    for (final key in cartRules.keys) {
      final item = cartItems[key];
      final rule = cartRules[key];

      if (item == null ||
          rule == null ||
          isDiscountValid(item.lineTotal ?? 0, rule))
        continue;
      double discount = _calculateDiscountAmount(item.lineTotal ?? 0, rule);
      item.lineTotal = max(0, (item.lineTotal ?? 0) - discount);
      appliedItemDiscount.add(
        AppliedItemDiscount(item: item, discountAmount: discount),
      );
    }
  }

  double _calculateDiscountAmount(double total, DiscountByType rule) {
    if (rule.discountType == DiscountType.percentage) {
      return total * (rule.value / 100);
    } else {
      return rule.value;
    }
  }

  bool isDiscountValid(double total, DiscountByType rule) {
    switch (rule.discountType) {
      case DiscountType.percentage:
        return rule.value <= 100;
      case DiscountType.amount:
        return rule.value <= total;
    }
  }
}
