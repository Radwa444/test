import '../model/InvoiceItem.dart';
import '../model/OfferAssembly.dart';

class GiftBuilder {
  Map<String, InvoiceItem> build(
      List<OfferAssembly> giftRules,
      int applyCount,
      List<InvoiceItem> items,
      int invoiceId,
      ) {
    final Map<String, InvoiceItem> giftMap = {};

    for (final gift in giftRules) {
      final key = '${gift.productID}_${gift.package}';
      final qty = (gift.qty ?? 0) * applyCount;

      if (qty <= 0) continue;

      giftMap[key] = InvoiceItem(
        invoiceId: invoiceId,
        packageId: gift.package,
        productId: gift.productID,
        productName: gift.name,
        unitPrice: 0,
        qty: (giftMap[key]?.qty ?? 0) + qty,
      );
    }

    return giftMap;
  }
}