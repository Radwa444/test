class InvoiceItem {

  int? id;
  int? invoiceId;
  int? productId;
  String? productName;
  double? qty;
  double? unitPrice;
  double? lineTotal;
  String? createdAt;
  String? updatedAt;
  int? remoteSync;
  int? pricingId;
  int? packageId;

  InvoiceItem({
    this.id,
    this.invoiceId,
    this.productId,
    this.productName,
    this.qty,
    this.unitPrice,
    this.lineTotal,
    this.createdAt,
    this.updatedAt,
    this.remoteSync,
    this.pricingId,
    this.packageId,
  });
}
