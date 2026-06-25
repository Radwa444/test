import '../model/AppliedOffer.dart';
import '../model/DiscountByType.dart';
import '../model/DiscountType.dart';
import '../model/InvoiceItem.dart';
import '../model/Offer.dart';
import '../model/OfferAssembly.dart';
import '../test.dart';
import 'OfferAbstract.dart';

class InvoiceDiscount extends OfferAbstract<double> {
  DiscountByType? discountRule;
  double total = 0;

  @override
  AppliedOffer Apply(Offer currentOffer) {
    final finalDiscount = 0.0;
    if (discountRule != null) _calculateDiscountAmount(total, discountRule!);
    if (finalDiscount == 0) {
      return AppliedOffer(offerId: 0, name: '', finalDiscount: 0);
    } else
      return AppliedOffer(
        offerId: currentOffer.id ?? 0,
        name: '',
        finalDiscount: finalDiscount,
      );
  }

  @override
  bool ValidateOffer(Offer offer, List<OfferAssembly> rules, double supTotal) {
    return (offer.offerType == OfferType.InvoiceDiscount &&
        validateCondition(supTotal, rules));
  }

  @override
  bool isApplied(List<InvoiceItem> items, List<OfferAssembly> rules) {
    throw UnimplementedError();
  }

  bool validateCondition(double subtotal, List<OfferAssembly> rules) {
    extractDiscountConditions(subtotal, rules);
    total = subtotal;
    return discountRule != null;
  }

  void extractDiscountConditions(double subtotal, List<OfferAssembly> rules) {
    for (var rule in rules) {
      if (rule.value > 0) {
        discountRule = DiscountByType(
          value: rule.value,
          discountType: DiscountType.amount,
        );
      } else {
        if (rule.pecentage > 0) {
          discountRule = DiscountByType(
            value: rule.pecentage,
            discountType: DiscountType.percentage,
          );
        }
      }
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
