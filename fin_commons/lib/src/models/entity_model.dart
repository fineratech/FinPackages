// ignore_for_file: public_member_api_docs, sort_constructors_first

import '../enums/gender.dart';

class EntityModal {
  final String? patientName;
  final Gender? gender;
  final DateTime? dateOfBirth;
  final DateTime? registrationDate;
  final String? location;

  EntityModal({
    this.patientName,
    this.gender,
    this.dateOfBirth,
    this.registrationDate,
    this.location,
  });
}
