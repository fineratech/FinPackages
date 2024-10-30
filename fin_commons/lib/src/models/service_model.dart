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
      'Name': name,
      'Type': type,
      'ResourceId': resourceId,
      'ServiceLocationId': serviceLocationId,
      'PickupLocationId': pickupLocationId,
      'DropoffLocationId': dropoffLocationId,
      'Cost': cost,
      'CustomerId': customerId,
      'ProviderId': providerId,
      'ScheduleId': scheduleId,
    };
  }

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      name: map['Name'] ?? '',
      type: map['Type'] ?? '',
      resourceId: map['ResourceId'] ?? '-1',
      serviceLocationId: map['ServiceLocationId'] ?? '-1',
      pickupLocationId: map['PickupLocationId'] ?? '-1',
      dropoffLocationId: map['DropoffLocationId'] ?? '-1',
      cost: map['Cost'] ?? '',
      customerId: map['CustomerId'] ?? '-1',
      providerId: map['ProviderId'] ?? '-1',
      scheduleId: map['ScheduleId'] ?? '-1',
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
