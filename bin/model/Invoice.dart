
class Invoice {

  int? id;
  int? customerId;
  String? date;
  String? orderType;
  double? totalAmount;
  String? paymentType;
  double? taxes;
  String? taxType;
  double? taxAmount;
  double? grossAmount;
  double? paid;
  String? createdAt;
  String? updatedAt;
  int? remoteSync;
  int? serverRecordId;
  int syncRecordOrigin;

  Invoice({
    this.id,
    this.customerId,
    this.date,
    this.orderType,
    this.totalAmount,
    this.paymentType,
    this.taxes,
    this.taxType,
    this.taxAmount,
    this.grossAmount,
    this.paid,
    this.createdAt,
    this.updatedAt,
    this.remoteSync,
    this.serverRecordId,
    this.syncRecordOrigin = 0,
  });

  /// Paid amount for display; falls back for legacy rows without [paid].
  double get displayPaidAmount =>
      paid ?? (paymentType == 'cash' ? (totalAmount ?? 0) : 0);
}
