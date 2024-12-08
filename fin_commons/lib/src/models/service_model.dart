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
  final String? serviceId;
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
    this.serviceId = "-1",
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
    String? serviceId,
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
      serviceId: serviceId ?? this.serviceId,
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
      'ServiceId': serviceId,
    };
  }

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      name: map['Name'] ?? '',
      type: map['Type'] ?? '',
      resourceId: (map['ResourceId'] ?? '-1').toString(),
      serviceLocationId: (map['ServiceLocationId'] ?? '-1').toString(),
      pickupLocationId: (map['PickupLocationId'] ?? '-1').toString(),
      dropoffLocationId: (map['DropoffLocationId'] ?? '-1').toString(),
      cost: (map['Cost'] ?? '').toString(),
      customerId: (map['CustomerId'] ?? '-1').toString(),
      providerId: (map['ProviderId'] ?? '-1').toString(),
      scheduleId: (map['ScheduleId'] ?? '-1').toString(),
      serviceId: (map['ID'] ?? '-1').toString(),
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
