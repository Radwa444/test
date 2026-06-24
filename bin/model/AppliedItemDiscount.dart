import 'InvoiceItem.dart';

class AppliedItemDiscount {
  final InvoiceItem item;
  final double discountAmount;

  AppliedItemDiscount({
    required this.item,
    required this.discountAmount,
  });
}