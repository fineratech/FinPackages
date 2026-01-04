// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:fin_commons/src/enums/gender.dart';
import 'package:fin_commons/src/enums/id_type.dart';
import 'package:fin_commons/src/models/service_model.dart';

class LawyerModel {
  final String lawyerName;
  final String lawyerQualification;
  final Gender gender;
  final DateTime dateOfBirth;
  final String certification;
  final String contactNumber;
  final List<ServiceModel> services;
  final IdType idType;
  final String idNumber;
  final String idExpiryDate;
  final String idIssuingState;
  final String idIssuingCountry;

  final String licenseType;
  final String licenseIssuingAuthority;
  final String licenseFirstName;
  final String licenseLastName;
  final String licenseIssuingCountry;
  final String licenseIssuingState;
  final String licenseNumber;
  final DateTime licenseExpiryDate;
  final DateTime licenseIssueDate;
  final File? licenseFrontImage;
  final File? licenseBackImage;
  final int? professionalId;
  final String? description;
  LawyerModel({
    required this.lawyerName,
    required this.lawyerQualification,
    required this.gender,
    required this.dateOfBirth,
    required this.certification,
    required this.contactNumber,
    required this.services,
    required this.idType,
    required this.idNumber,
    required this.idExpiryDate,
    required this.idIssuingState,
    required this.idIssuingCountry,
    required this.licenseIssuingAuthority,
    required this.licenseFirstName,
    required this.licenseLastName,
    required this.licenseIssuingCountry,
    required this.licenseIssuingState,
    required this.licenseNumber,
    required this.licenseExpiryDate,
    required this.licenseIssueDate,
    required this.licenseType,
    this.licenseFrontImage,
    this.licenseBackImage,
    this.professionalId,
    this.description,
  });

  LawyerModel copyWith({
    String? lawyerName,
    String? lawyerQualification,
    Gender? gender,
    DateTime? dateOfBirth,
    String? certification,
    String? contactNumber,
    List<ServiceModel>? services,
    IdType? idType,
    String? idNumber,
    String? idExpiryDate,
    String? idIssuingState,
    String? idIssuingCountry,
    String? licenseIssuingAuthority,
    String? licenseFirstName,
    String? licenseLastName,
    String? licenseIssuingCountry,
    String? licenseIssuingState,
    String? licenseNumber,
    DateTime? licenseExpiryDate,
    DateTime? licenseIssueDate,
    File? licenseFrontImage,
    File? licenseBackImage,
    String? licenseType,
    int? professionalId,
    String? description,
  }) {
    return LawyerModel(
      lawyerName: lawyerName ?? this.lawyerName,
      lawyerQualification: lawyerQualification ?? this.lawyerQualification,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      certification: certification ?? this.certification,
      contactNumber: contactNumber ?? this.contactNumber,
      services: services ?? this.services,
      idType: idType ?? this.idType,
      idNumber: idNumber ?? this.idNumber,
      idExpiryDate: idExpiryDate ?? this.idExpiryDate,
      idIssuingState: idIssuingState ?? this.idIssuingState,
      idIssuingCountry: idIssuingCountry ?? this.idIssuingCountry,
      licenseIssuingAuthority:
          licenseIssuingAuthority ?? this.licenseIssuingAuthority,
      licenseFirstName: licenseFirstName ?? this.licenseFirstName,
      licenseLastName: licenseLastName ?? this.licenseLastName,
      licenseIssuingCountry:
          licenseIssuingCountry ?? this.licenseIssuingCountry,
      licenseIssuingState: licenseIssuingState ?? this.licenseIssuingState,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,
      licenseIssueDate: licenseIssueDate ?? this.licenseIssueDate,
      licenseFrontImage: licenseFrontImage ?? this.licenseFrontImage,
      licenseBackImage: licenseBackImage ?? this.licenseBackImage,
      licenseType: licenseType ?? this.licenseType,
      professionalId: professionalId ?? this.professionalId,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lawyerName': lawyerName,
      'lawyerQualification': lawyerQualification,
      'gender': gender.name,
      'dateOfBirth': dateOfBirth.millisecondsSinceEpoch,
      'certification': certification,
      'contactNumber': contactNumber,
      'services': services.map((x) => x.toMap()).toList(),
      'idType': idType.name,
      'idNumber': idNumber,
      'idExpiryDate': idExpiryDate,
      'idIssuingState': idIssuingState,
      'idIssuingCountry': idIssuingCountry,
      'licenseIssuingAuthority': licenseIssuingAuthority,
      'licenseFirstName': licenseFirstName,
      'licenseLastName': licenseLastName,
      'licenseIssuingCountry': licenseIssuingCountry,
      'licenseIssuingState': licenseIssuingState,
      'licenseNumber': licenseNumber,
      'licenseExpiryDate': licenseExpiryDate.millisecondsSinceEpoch,
      'licenseIssueDate': licenseIssueDate.millisecondsSinceEpoch,
      'licenseType': licenseType,
      'professionalId': professionalId,
      'description': description,
    };
  }

  factory LawyerModel.fromMap(Map<String, dynamic> map) {
    return LawyerModel(
      lawyerName: map['lawyerName'] as String,
      lawyerQualification: map['lawyerQualification'] as String,
      gender: Gender.fromString(map['gender']),
      dateOfBirth:
          DateTime.fromMillisecondsSinceEpoch(map['dateOfBirth'] as int),
      certification: map['certification'] as String,
      contactNumber: map['contactNumber'] as String,
      services: List<ServiceModel>.from(
        (map['services'] as List<int>).map<ServiceModel>(
          (x) => ServiceModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      idType: IdType.fromString(map['idType']),
      idNumber: map['idNumber'] as String,
      idExpiryDate: map['idExpiryDate'] as String,
      idIssuingState: map['idIssuingState'] as String,
      idIssuingCountry: map['idIssuingCountry'] as String,
      licenseIssuingAuthority: map['licenseIssuingAuthority'] as String,
      licenseFirstName: map['licenseFirstName'] as String,
      licenseLastName: map['licenseLastName'] as String,
      licenseIssuingCountry: map['licenseIssuingCountry'] as String,
      licenseIssuingState: map['licenseIssuingState'] as String,
      licenseNumber: map['licenseNumber'] as String,
      licenseExpiryDate:
          DateTime.fromMillisecondsSinceEpoch(map['licenseExpiryDate'] as int),
      licenseIssueDate:
          DateTime.fromMillisecondsSinceEpoch(map['licenseIssueDate'] as int),
      licenseType: map['licenseType'] as String,
      professionalId: map['professionalId'] as int,
      description: map['description'],
    );
  }

  factory LawyerModel.fromAppObject(Map<String, dynamic> map) {
    return LawyerModel(
      lawyerName: map['Name'] ?? '',
      professionalId: int.tryParse(map['ProfessionalId'] ?? ''),
      lawyerQualification: map['LawyerQualification'] ?? '',
      gender: Gender.fromString(map['Gender'] ?? ''),
      dateOfBirth: DateTime.tryParse(map['DOB'] ?? '') ?? DateTime.now(),
      certification: map['Certification'] ?? '',
      contactNumber: map['ContactNumber'] ?? '',
      services: List<ServiceModel>.from(
        (map['_SupportedServices'] as List).map<ServiceModel>(
          (service) => ServiceModel.fromMap(service as Map<String, dynamic>),
        ),
      ),
      idType: IdType.fromString(map['IdType'] ?? ''),
      idNumber: map['idNumber'] ?? '',
      idExpiryDate: map['idExpiryDate'] ?? '',
      idIssuingState: map['idIssuingState'] ?? '',
      idIssuingCountry: map['idIssuingCountry'] ?? '',
      licenseIssuingAuthority: map['LicenseIssuingAuthority'] ?? '',
      licenseFirstName: map['LicenseFirstName'] ?? '',
      licenseLastName: map['LicenseLastName'] ?? '',
      licenseIssuingCountry: map['License_IssuingCountry'] ?? '',
      licenseIssuingState: map['License_IssuingState'] ?? '',
      licenseNumber: (map['LicenseNumber'] ?? '').toString(),
      licenseExpiryDate:
          DateTime.tryParse(map['License_ExpiryDate'] ?? '') ?? DateTime.now(),
      licenseIssueDate:
          DateTime.tryParse(map['License_IssueDate'] ?? '') ?? DateTime.now(),
      licenseType: map['LicenseType'] ?? '',
      description: map['Description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LawyerModel.fromJson(String source) =>
      LawyerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LawyerModel(lawyerName: $lawyerName, lawyerQualification: $lawyerQualification, gender: $gender, dateOfBirth: $dateOfBirth, certification: $certification, contactNumber: $contactNumber, services: $services, idType: $idType, idNumber: $idNumber, idExpiryDate: $idExpiryDate, idIssuingState: $idIssuingState, idIssuingCountry: $idIssuingCountry, licenseIssuingAuthority: $licenseIssuingAuthority, licenseFirstName: $licenseFirstName, licenseLastName: $licenseLastName, licenseIssuingCountry: $licenseIssuingCountry, licenseIssuingState: $licenseIssuingState, licenseNumber: $licenseNumber, licenseExpiryDate: $licenseExpiryDate, licenseIssueDate: $licenseIssueDate)';
  }

  @override
  bool operator ==(covariant LawyerModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.lawyerName == lawyerName &&
        other.lawyerQualification == lawyerQualification &&
        other.gender == gender &&
        other.dateOfBirth == dateOfBirth &&
        other.certification == certification &&
        other.contactNumber == contactNumber &&
        listEquals(other.services, services) &&
        other.idType == idType &&
        other.idNumber == idNumber &&
        other.idExpiryDate == idExpiryDate &&
        other.idIssuingState == idIssuingState &&
        other.idIssuingCountry == idIssuingCountry &&
        other.licenseIssuingAuthority == licenseIssuingAuthority &&
        other.licenseFirstName == licenseFirstName &&
        other.licenseLastName == licenseLastName &&
        other.licenseIssuingCountry == licenseIssuingCountry &&
        other.licenseIssuingState == licenseIssuingState &&
        other.licenseNumber == licenseNumber &&
        other.licenseExpiryDate == licenseExpiryDate &&
        other.description == description &&
        other.licenseIssueDate == licenseIssueDate;
  }

  @override
  int get hashCode {
    return lawyerName.hashCode ^
        lawyerQualification.hashCode ^
        gender.hashCode ^
        dateOfBirth.hashCode ^
        certification.hashCode ^
        contactNumber.hashCode ^
        services.hashCode ^
        idType.hashCode ^
        idNumber.hashCode ^
        idExpiryDate.hashCode ^
        idIssuingState.hashCode ^
        idIssuingCountry.hashCode ^
        licenseIssuingAuthority.hashCode ^
        licenseFirstName.hashCode ^
        licenseLastName.hashCode ^
        licenseIssuingCountry.hashCode ^
        licenseIssuingState.hashCode ^
        licenseNumber.hashCode ^
        licenseExpiryDate.hashCode ^
        licenseIssueDate.hashCode;
  }
}
