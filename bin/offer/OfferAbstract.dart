import '../model/AppliedOffer.dart';
import '../model/InvoiceItem.dart';
import '../model/Offer.dart';
import '../model/OfferAssembly.dart';

abstract class OfferAbstract<T> {
  AppliedOffer Apply(Offer currentOffer);
  bool ValidateOffer(
    Offer offer,
    List<OfferAssembly> rules,
      T data,
  );
  bool isApplied(List<InvoiceItem> items, List<OfferAssembly> rules);

}
