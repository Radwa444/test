import '../model/AppliedOffer.dart';
import '../model/Customer.dart';
import '../model/InvoiceItem.dart';
import '../model/Offer.dart';
import '../model/OfferAssembly.dart';
import 'OfferAbstract.dart';

class CustomerProduct extends OfferAbstract<Customer> {
  @override
  AppliedOffer Apply(Offer currentOffer) {
    // TODO: implement Apply
    throw UnimplementedError();
  }

  @override
  bool ValidateOffer(Offer offer, List<OfferAssembly> rules, Customer? customer) {
    // TODO: implement ValidateOffer
    throw UnimplementedError();
  }

  @override
  bool isApplied(List<InvoiceItem> items, List<OfferAssembly> rules) {
    // TODO: implement isApplied
    throw UnimplementedError();
  }
}