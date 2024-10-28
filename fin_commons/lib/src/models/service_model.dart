class ServiceModel {
  final String name;
  final String type;
  final String? resourceId;
  final String? serviceLocationId; //-1
  final String? pickupLocationId; //-1
  final String? dropoffLocationId; //-1
  final String cost;
  final String? customerId; //-1
  final String providerId; //Professional Id or Merchant Id
  final String? scheduleId; //-1
  ServiceModel({
    required this.name,
    required this.type,
    this.resourceId = "-1",
    this.serviceLocationId = "-1",
    this.pickupLocationId = "-1",
    this.dropoffLocationId = "-1",
    required this.cost,
    this.customerId = "-1",
    required this.providerId,
    this.scheduleId = "-1",
  });

  ServiceModel copyWith({
    String? name,
    String? type,
    String? resourceId,
    String? serviceLocationId,
    String? pickupLocationId,
    String? dropoffLocationId,
    String? cost,
    String? customerId,
    String? providerId,
    String? scheduleId,
  }) {
    return ServiceModel(
      name: name ?? this.name,
      type: type ?? this.type,
      resourceId: resourceId ?? this.resourceId,
      serviceLocationId: serviceLocationId ?? this.serviceLocationId,
      pickupLocationId: pickupLocationId ?? this.pickupLocationId,
      dropoffLocationId: dropoffLocationId ?? this.dropoffLocationId,
      cost: cost ?? this.cost,
      customerId: customerId ?? this.customerId,
      providerId: providerId ?? this.providerId,
      scheduleId: scheduleId ?? this.scheduleId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'type': type,
      'resourceId': resourceId,
      'serviceLocationId': serviceLocationId,
      'pickupLocationId': pickupLocationId,
      'dropoffLocationId': dropoffLocationId,
      'cost': cost,
      'customerId': customerId,
      'providerId': providerId,
      'scheduleId': scheduleId,
    };
  }

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      name: map['name'] as String,
      type: map['type'] as String,
      resourceId:
          map['resourceId'] != null ? map['resourceId'] as String : null,
      serviceLocationId: map['serviceLocationId'] != null
          ? map['serviceLocationId'] as String
          : null,
      pickupLocationId: map['pickupLocationId'] != null
          ? map['pickupLocationId'] as String
          : null,
      dropoffLocationId: map['dropoffLocationId'] != null
          ? map['dropoffLocationId'] as String
          : null,
      cost: map['cost'] as String,
      customerId:
          map['customerId'] != null ? map['customerId'] as String : null,
      providerId: map['providerId'] as String,
      scheduleId:
          map['scheduleId'] != null ? map['scheduleId'] as String : null,
    );
  }

  @override
  String toString() {
    return 'ServiceModel(name: $name, type: $type, resourceId: $resourceId, serviceLocationId: $serviceLocationId, pickupLocationId: $pickupLocationId, dropoffLocationId: $dropoffLocationId, cost: $cost, customerId: $customerId, providerId: $providerId, scheduleId: $scheduleId)';
  }

  @override
  bool operator ==(covariant ServiceModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.type == type &&
        other.resourceId == resourceId &&
        other.serviceLocationId == serviceLocationId &&
        other.pickupLocationId == pickupLocationId &&
        other.dropoffLocationId == dropoffLocationId &&
        other.cost == cost &&
        other.customerId == customerId &&
        other.providerId == providerId &&
        other.scheduleId == scheduleId;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        type.hashCode ^
        resourceId.hashCode ^
        serviceLocationId.hashCode ^
        pickupLocationId.hashCode ^
        dropoffLocationId.hashCode ^
        cost.hashCode ^
        customerId.hashCode ^
        providerId.hashCode ^
        scheduleId.hashCode;
  }
}
