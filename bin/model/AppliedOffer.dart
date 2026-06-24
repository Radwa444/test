import 'AppliedItemDiscount.dart';
import 'InvoiceItem.dart';

class AppliedOffer {
  final int offerId;
  final List<InvoiceItem> giftItems;
  final String name;
  final List<AppliedItemDiscount> discounts;

  AppliedOffer({
    required this.offerId,
     this.giftItems = const [],
    required this.name,
    this.discounts=const []
  });
}