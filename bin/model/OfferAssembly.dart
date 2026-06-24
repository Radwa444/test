class OfferAssembly {
  int? id;

  int offerId;
  int? customerID;
  int? productID;
  int? package;
  int? state;
  String name;
  String startDate;
  String endDate;
  double value;
  double pecentage;
  double? qty;
  String createAt;
  String updateAt;
  int remoteSync;
  int updateSync;
  int? serverRecordId;
  int? syncRecordOrigin;

  OfferAssembly({
    this.id,
    required this.offerId,
    this.customerID,
    this.productID,
    this.package,
    this.state,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.value,
    required this.pecentage,
    required this.createAt,
    required this.updateAt,
    required this.remoteSync,
    required this.updateSync,
    this.qty,
    this.serverRecordId,
    this.syncRecordOrigin = 0,
  });

  OfferAssembly copyWith(
      {int? id,
        int? offerId,
        int? customerID,
        int? productID,
        int? package,
        int? state,
        String? name,
        String? startDate,
        String? endDate,
        double? value,
        double? pecentage,
        String? createAt,
        String? updateAt,
        int? remoteSync,
        int? updateSync,
        int? serverRecordId,
        int? syncRecordOrigin,
        double? qty}) {
    return OfferAssembly(
      id: id ?? this.id,
      offerId: offerId ?? this.offerId,
      customerID: customerID ?? this.customerID,
      productID: productID ?? this.productID,
      package: package ?? this.package,
      state: state ?? this.state,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      value: value ?? this.value,
      pecentage: pecentage ?? this.pecentage,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      remoteSync: remoteSync ?? this.remoteSync,
      updateSync: updateSync ?? this.updateSync,
      qty: qty ?? this.qty,
      serverRecordId: serverRecordId ?? this.serverRecordId,
      syncRecordOrigin: syncRecordOrigin ?? this.syncRecordOrigin,
    );
  }

  bool get isActive {
    try {
      final now = DateTime.now();
      final start = DateTime.parse(startDate);
      final end = DateTime.parse(endDate);
      return !now.isBefore(start) && !now.isAfter(end);
    } catch (_) {
      return false;
    }
  }

  bool get isGlobal => customerID == null;
  bool get isForCustomer => customerID != null;
  bool get isForProduct => productID != null;
}
