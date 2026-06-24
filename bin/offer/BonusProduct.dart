import '../model/AppliedOffer.dart';
import '../model/Customer.dart';
import '../model/InvoiceItem.dart';
import '../model/Offer.dart';
import '../model/OfferAssembly.dart';
import '../test.dart';
import 'OfferAbstract.dart';

class Bonusproduct extends OfferAbstract<List<InvoiceItem>> {
  Map<String, double> cartItems = {};
  Map<String, double> cartRules = {};
  List<OfferAssembly> gifts=[];

//ValidateOffer must be called before Apply
  @override
  AppliedOffer Apply(Offer currentOffer) {
    final counter = calculateExecutionCount();

    if (counter <= 0 || gifts.isEmpty) {
      return AppliedOffer(
        offerId: 0,
        giftItems: [],
        name: '',
      );
    }

    final giftItems = <InvoiceItem>[];

    for (final gift in gifts) {
      giftItems.add(
        InvoiceItem(
          productId: gift.productID,
          packageId: gift.package,
          productName: gift.name,
          unitPrice: 0,
          qty: (gift.qty ?? 0) * counter,
        ),
      );
    }

    return AppliedOffer(
      offerId: currentOffer.id ?? 0,
      name: currentOffer.name,
      giftItems: giftItems,
    );
  }

  @override
  bool ValidateOffer(
    Offer offer,
    List<OfferAssembly> rules,
    List<InvoiceItem> items,
  ) {
    cartItems.clear();
    cartRules.clear();
    gifts.clear();
    return (offer.offerType == OfferType.buyXGetY &&
        validateCondition(rules, items));
  }

  @override
  bool isApplied(List<InvoiceItem> items, List<OfferAssembly> rules) {
    // TODO: implement isApplied
    throw UnimplementedError();
  }

  bool validateCondition(List<OfferAssembly> rules, List<InvoiceItem> items) {
    if (rules.isEmpty || items.isEmpty) return false;
    final newRules = extractBonusConditions(rules);
    //check condition
    for (var item in items) {
      final key = '${item.productId}_${item.packageId}';
      cartItems[key] = (cartItems[key] ?? 0) + (item.qty ?? 0);
    }
    for (var rule in newRules) {
      final key = '${rule.productID}_${rule.package}';
      cartRules[key] =
          (cartRules[key] ?? 0) + (rule.qty ?? 0);
    }
    if (cartRules.isEmpty || cartItems.isEmpty) return false;

    return cartRules.keys.every((key) {
      if (cartItems.containsKey(key)) {
        if (cartItems[key]! >= cartRules[key]!) return true;
      }
      return false;
    });
  }

  List<OfferAssembly> extractBonusConditions(List<OfferAssembly> rules) {
     gifts = rules.where((g) => g.state == 0).toList();

    return rules.where((r) => r.state == 1).toList();
  }

  int calculateExecutionCount() {
    if (cartRules.isEmpty) return 0;
    final ratios = <double>[];
    for (var key in cartRules.keys) {
      if (!(cartItems.containsKey(key))) return 0;
      ratios.add((cartItems[key] ?? 0) / (cartRules[key] ?? 1));
    }
    return ratios.reduce((a, b) => a < b ? a : b).toInt();
  }


}
