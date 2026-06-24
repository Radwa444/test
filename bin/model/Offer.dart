
class Offer {

  int? id;

  String name;
  String description;
  String offerType;

  String? createdAt;
  String? updatedAt;
  int? remoteSync;
  int? serverRecordId;
  int? syncRecordOrigin;

  Offer({
    this.id,
    required this.name,
    required this.description,
    required this.offerType,
    this.createdAt,
    this.updatedAt,
    this.remoteSync = 0,
    this.serverRecordId,
    this.syncRecordOrigin = 0,
  });

  Offer copyWith({
    int? id,
    String? name,
    String? description,
    String? offerType,
    String? createdAt,
    String? updatedAt,
    int? remoteSync,
    int? serverRecordId,
    int? syncRecordOrigin,
  }) {
    return Offer(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      offerType: offerType ?? this.offerType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      remoteSync: remoteSync ?? this.remoteSync,
      serverRecordId: serverRecordId ?? this.serverRecordId,
      syncRecordOrigin: syncRecordOrigin ?? this.syncRecordOrigin,
    );
  }
}