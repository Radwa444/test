import 'dart:math';

import '../model/AppliedItemDiscount.dart';
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
  Map<String, InvoiceItem> cartItems = {};
  List< AppliedItemDiscount> appliedItemDiscount=[];

  @override
  AppliedOffer Apply(Offer currentOffer) {
    calculateDiscount();
    if(appliedItemDiscount.isNotEmpty) {
      return AppliedOffer(offerId: currentOffer.id??0, name:'',discounts: appliedItemDiscount);
    }else
      return AppliedOffer(
        offerId: 0,
        name: '',
      );
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
    return (offer.offerType == OfferType.productDiscount.value&&buildDiscountContext(model.items, rules));
  }

  @override
  bool isApplied(List<InvoiceItem> items, List<OfferAssembly> rules) {
    // TODO: implement isApplied
    throw UnimplementedError();
  }

  bool buildDiscountContext(List<InvoiceItem> items, List<OfferAssembly> rules) {
    if (items.isEmpty || rules.isEmpty) return false;
    extractDiscountConditions(rules);
    buildEligibleItemsMap(items);
    return(cartItems.isNotEmpty && cartRules.isNotEmpty);
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
       double discount;
      if (item == null || rule == null) continue;

      if (rule.discountType == DiscountType.percentage) {
         discount =
            (item.lineTotal ?? 0) * (rule.value / 100);

        item.lineTotal =
            max(0, (item.lineTotal ?? 0) - discount);

      } else {
        discount=rule.value;
        item.lineTotal =
            max(0, (item.lineTotal ?? 0) - discount);

      }
      appliedItemDiscount.add(AppliedItemDiscount(item: item, discountAmount: discount));
    }
  }
}
