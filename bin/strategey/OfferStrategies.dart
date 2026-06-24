import '../model/AppliedOffer.dart';
import '../model/Customer.dart';
import '../model/InvoiceItem.dart';
import '../model/Offer.dart';
import '../model/OfferAssembly.dart';


abstract class OfferStrategies {
  bool isApply(Offer offer);
  AppliedOffer apply(
      Offer offer,
      List<OfferAssembly> rules,
      List<InvoiceItem> items,
      Customer? customer,
      );
}
