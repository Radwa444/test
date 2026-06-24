import '../helper/GiftBuilder.dart';
import '../helper/OfferCalculator.dart';
import '../helper/OfferValidator.dart';
import '../model/AppliedOffer.dart';
import '../model/Customer.dart';
import '../model/InvoiceItem.dart';
import '../model/Offer.dart';
import '../model/OfferAssembly.dart';
import '../test.dart';
import 'OfferStrategies.dart';

class BuyXGetYStrategy implements OfferStrategies {
  final OfferValidator validator = OfferValidator();
  final OfferCalculator calculator = OfferCalculator();
  final GiftBuilder builder = GiftBuilder();

  @override
  AppliedOffer apply(
      Offer offer,
      List<OfferAssembly> rules,
      List<InvoiceItem> items,
      Customer? customer,
      ) {
    final giftRules = rules.where((r) => r.state == 0).toList();
    final buyRules = rules.where((r) => r.state == 1).toList();

    final cartItems = <String, double>{};

    for (final item in items) {
      final key = '${item.productId}_${item.packageId}';
      cartItems[key] = (cartItems[key] ?? 0) + (item.qty ?? 0);
    }

    // 1. validate
    if (buyRules.isEmpty || !validator.isValid(buyRules, cartItems)) {
      return AppliedOffer(
        offerId: offer.id ?? 0,
        giftItems: [],
        name: offer.name,
      );
    }

    // 2. calculate
    final applyCount = calculator.calculateApplyCount(buyRules, cartItems);

    if (applyCount <= 0) {
      return AppliedOffer(
        offerId: offer.id ?? 0,
        giftItems: [],
        name: offer.name,
      );
    }

    // 3. build gifts
    final gifts = builder.build(
      giftRules,
      applyCount,
      items,
      items.first.invoiceId ?? 0,
    );

    return AppliedOffer(
      offerId: offer.id ?? 0,
      giftItems: gifts.values.toList(),
      name: offer.name,
    );
  }

  @override
  bool isApply(Offer offer) {
    return offer.offerType == OfferType.buyXGetY.value;
  }
}
