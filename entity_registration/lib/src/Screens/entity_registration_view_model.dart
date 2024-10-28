import 'package:fin_api_functions/fin_api_functions.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class EntityRegistrationViewModel extends ChangeNotifier {
  late ApiFunctionsService _apiFunctionsService;
  final logger = Logger();
  EntityRegistrationViewModel() {
    _apiFunctionsService = ApiFunctionsService(
      logger: logger,
    );
  }

  Future<void> registerProfessional(EntityModal entity) async {
    // await _apiFunctionsService.registerProfessional(
    //   ownerID,
    //   category,
    //   type,
    //   companyId,
    //   idType,
    //   idNumber,
    //   idExpiryDate,
    //   idIssuingState,
    //   idIssuingCountry,
    //   licenseNumber,
    //   licenseType,
    //   licenseExpiryDate,
    //   licenseIssuingState,
    //   licenseIssuingCountry,
    //   gender,
    //   dob,
    // );
  }
}
