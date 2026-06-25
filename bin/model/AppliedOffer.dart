import 'AppliedItemDiscount.dart';
import 'InvoiceItem.dart';

class AppliedOffer {
  final int offerId;
  final List<InvoiceItem> giftItems;
  final String name;
  final List<AppliedItemDiscount> discounts;
  final double finalDiscount;

  AppliedOffer({
    required this.offerId,
     this.giftItems = const [],
    required this.name,
    this.discounts=const [],
    this.finalDiscount=0
  });
}