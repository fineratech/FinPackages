class ClientModel {
  final String name;
  final String ownerId;
  final String companyId;
  final String recordFriendlyName;
  final String clientRecordNumber;
  final String idType;
  final String idNumber;
  final String idExpiry;
  final String idIssuingState;
  final String idIssuingCountry;
  final String gender;
  final String dob;
  final String locationId;
  final String clientId;
  ClientModel({
    required this.name,
    required this.ownerId,
    required this.companyId,
    required this.recordFriendlyName,
    required this.idType,
    required this.idNumber,
    required this.idExpiry,
    required this.idIssuingState,
    required this.idIssuingCountry,
    required this.gender,
    required this.dob,
    required this.locationId,
    this.clientId = '',
    this.clientRecordNumber = '-1',
  });

  factory ClientModel.fromAppObject(Map<String, dynamic> map) {
    return ClientModel(
      name: map['Name'] ?? '',
      ownerId: map['OwnerId'] ?? '',
      companyId: map['CompanyId'] ?? '',
      recordFriendlyName: map['RecordFriendlyName'] ?? '',
      clientRecordNumber: map['ClientRecordNumber'] ?? '-1',
      idType: map['IdType'] ?? '',
      idNumber: map['IdNumber'] ?? '',
      idExpiry: map['IdExpiry'] ?? '',
      idIssuingState: map['IdIssuingState'] ?? '',
      idIssuingCountry: map['IdIssuingCountry'] ?? '',
      gender: map['Gender'] ?? '',
      dob: map['DOB'] ?? '',
      locationId: map['LocationId'] ?? '',
      clientId: map['ClientId'] ?? '',
    );
  }

  @override
  bool operator ==(covariant ClientModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.ownerId == ownerId &&
        other.companyId == companyId &&
        other.recordFriendlyName == recordFriendlyName &&
        other.idType == idType &&
        other.idNumber == idNumber &&
        other.idExpiry == idExpiry &&
        other.idIssuingState == idIssuingState &&
        other.idIssuingCountry == idIssuingCountry &&
        other.gender == gender &&
        other.dob == dob &&
        other.clientId == clientId &&
        other.locationId == locationId;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        ownerId.hashCode ^
        companyId.hashCode ^
        recordFriendlyName.hashCode ^
        idType.hashCode ^
        idNumber.hashCode ^
        idExpiry.hashCode ^
        idIssuingState.hashCode ^
        idIssuingCountry.hashCode ^
        gender.hashCode ^
        dob.hashCode ^
        clientId.hashCode ^
        locationId.hashCode;
  }
}
