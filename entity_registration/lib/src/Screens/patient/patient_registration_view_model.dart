import 'package:fin_api_functions/fin_api_functions.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:logger/logger.dart';

class PatientRegistrationViewModel extends ChangeNotifier {
  PatientRegistrationViewModel(
      {required this.merchantId,
      required this.userId,
      required this.type,
      required this.locationId}) {
    initialize();
  }

  late ApiFunctionsService _apiFunctionsService;
  final Logger logger = Logger();
  final String merchantId;
  final String userId;
  final EntityType type;
  final String locationId;

  //Form Key
  final formKey = GlobalKey<FormBuilderState>();

  // Fields
  Gender? _selectedGender;
  DateTime? _dateOfBirth;
  DateTime? _registrationDate;
  DateTime? _idIssueDate;
  DateTime? _idExpiryDate;
  IdType? _idType;
  String? _country;
  String? _state;
  String? _city;
  bool _isLoading = false;

  //TextEditingControllers
  late TextEditingController patientNameController;
  late TextEditingController locationController;
  late TextEditingController issuingAuthorityController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController idNumberController;

  // Getters
  Gender? get selectedGender => _selectedGender;
  DateTime? get dateOfBirth => _dateOfBirth;
  DateTime? get registrationDate => _registrationDate;
  String? get country => _country;
  String? get state => _state;
  String? get city => _city;
  DateTime? get idIssueDate => _idIssueDate;
  DateTime? get idExpiryDate => _idExpiryDate;
  IdType? get idType => _idType;
  bool get isLoading => _isLoading;

  // Setters
  set selectedGender(Gender? gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  set dateOfBirth(DateTime? date) {
    _dateOfBirth = date;
    notifyListeners();
  }

  set registrationDate(DateTime? date) {
    _registrationDate = date;
    notifyListeners();
  }

  set country(String? value) {
    _country = value;
    notifyListeners();
  }

  set state(String? value) {
    _state = value;
    notifyListeners();
  }

  set city(String? value) {
    _city = value;
    notifyListeners();
  }

  set idIssueDate(DateTime? date) {
    _idIssueDate = date;
    notifyListeners();
  }

  set idExpiryDate(DateTime? date) {
    _idExpiryDate = date;
    notifyListeners();
  }

  set idType(IdType? idType) {
    _idType = idType;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void initialize() {
    _apiFunctionsService = ApiFunctionsService(logger: logger);
    patientNameController = TextEditingController();
    locationController = TextEditingController();
    issuingAuthorityController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    idNumberController = TextEditingController();
  }

  bool isFormValid() {
    return formKey.currentState?.saveAndValidate() ?? false;
  }

  Future<int?> registerPatient({
    required PatientModel patient,
    required BuildContext context,
  }) async {
    isLoading = true;
    int? patientId = await _apiFunctionsService.registerPatient(
      userId,
      'healthcare',
      type.name,
      merchantId,
      "-1",
      patient.idType,
      patient.idNumber,
      patient.idExpiry,
      patient.idIssuingState,
      patient.idIssuingCountry,
      patient.gender,
      patient.dob,
      locationId,
    );
    isLoading = false;
    if (patientId case -1 || null) {
      if (context.mounted) {
        Utils.showErrorToast(
          context: context,
          message: "Failed to register patient",
        );
      }
    }
    return patientId;
  }

  @override
  void dispose() {
    patientNameController.dispose();
    locationController.dispose();
    issuingAuthorityController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    idNumberController.dispose();
    super.dispose();
  }
}
