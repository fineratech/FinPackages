class PatientModel {
  final String name;
  final String ownerId;
  final String companyId;
  final String mrn;
  final String idType;
  final String idNumber;
  final String idExpiry;
  final String idIssuingState;
  final String idIssuingCountry;
  final String gender;
  final String dob;
  final String locationId;
  PatientModel({
    required this.name,
    required this.ownerId,
    required this.companyId,
    required this.mrn,
    required this.idType,
    required this.idNumber,
    required this.idExpiry,
    required this.idIssuingState,
    required this.idIssuingCountry,
    required this.gender,
    required this.dob,
    required this.locationId,
  });

  PatientModel copyWith({
    String? name,
    String? ownerId,
    String? companyId,
    String? mrn,
    String? idType,
    String? idNumber,
    String? idExpiry,
    String? idIssuingState,
    String? idIssuingCountry,
    String? gender,
    String? dob,
    String? locationId,
  }) {
    return PatientModel(
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      companyId: companyId ?? this.companyId,
      mrn: mrn ?? this.mrn,
      idType: idType ?? this.idType,
      idNumber: idNumber ?? this.idNumber,
      idExpiry: idExpiry ?? this.idExpiry,
      idIssuingState: idIssuingState ?? this.idIssuingState,
      idIssuingCountry: idIssuingCountry ?? this.idIssuingCountry,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      locationId: locationId ?? this.locationId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'ownerId': ownerId,
      'companyId': companyId,
      'mrn': mrn,
      'idType': idType,
      'idNumber': idNumber,
      'idExpiry': idExpiry,
      'idIssuingState': idIssuingState,
      'idIssuingCountry': idIssuingCountry,
      'gender': gender,
      'dob': dob,
      'locationId': locationId,
    };
  }

  factory PatientModel.fromMap(Map<String, dynamic> map) {
    return PatientModel(
      name: map['name'] as String,
      ownerId: map['ownerId'] as String,
      companyId: map['companyId'] as String,
      mrn: map['mrn'] as String,
      idType: map['idType'] as String,
      idNumber: map['idNumber'] as String,
      idExpiry: map['idExpiry'] as String,
      idIssuingState: map['idIssuingState'] as String,
      idIssuingCountry: map['idIssuingCountry'] as String,
      gender: map['gender'] as String,
      dob: map['dob'] as String,
      locationId: map['locationId'] as String,
    );
  }

  @override
  bool operator ==(covariant PatientModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.ownerId == ownerId &&
        other.companyId == companyId &&
        other.mrn == mrn &&
        other.idType == idType &&
        other.idNumber == idNumber &&
        other.idExpiry == idExpiry &&
        other.idIssuingState == idIssuingState &&
        other.idIssuingCountry == idIssuingCountry &&
        other.gender == gender &&
        other.dob == dob &&
        other.locationId == locationId;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        ownerId.hashCode ^
        companyId.hashCode ^
        mrn.hashCode ^
        idType.hashCode ^
        idNumber.hashCode ^
        idExpiry.hashCode ^
        idIssuingState.hashCode ^
        idIssuingCountry.hashCode ^
        gender.hashCode ^
        dob.hashCode ^
        locationId.hashCode;
  }
}
