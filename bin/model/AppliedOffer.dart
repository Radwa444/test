import 'InvoiceItem.dart';

class AppliedOffer {
  final int offerId;
  final List<InvoiceItem> giftItems;
  final String name;

  AppliedOffer({
    required this.offerId,
    required this.giftItems,
    required this.name,
  });
}