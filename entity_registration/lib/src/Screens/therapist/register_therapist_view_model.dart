import 'dart:io';

import 'package:entity_registration/src/constants/app_strings.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class RegisterTherapistViewModel extends ChangeNotifier {
  RegisterTherapistViewModel() {
    initialize();
  }

  //Form Key
  final formKey = GlobalKey<FormBuilderState>();

  // Fields
  Gender? _selectedGender;
  DateTime? _dateOfBirth;
  DateTime? _licenseIssueDate;
  DateTime? _licenseExpiryDate;
  bool _showLicenseFields = false;
  List<Service> _selectedServices = [];
  File? _licenseFrontImage;
  File? _licenseBackImage;

  // Getters
  Gender? get selectedGender => _selectedGender;
  DateTime? get dateOfBirth => _dateOfBirth;
  DateTime? get licenseIssueDate => _licenseIssueDate;
  DateTime? get licenseExpiryDate => _licenseExpiryDate;
  bool get showLicenseFields => _showLicenseFields;
  List<Service> get selectedServices => _selectedServices;
  File? get licenseFrontImage => _licenseFrontImage;
  File? get licenseBackImage => _licenseBackImage;

  // Setters
  set selectedGender(Gender? gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  set dateOfBirth(DateTime? date) {
    _dateOfBirth = date;
    notifyListeners();
  }

  set licenseIssueDate(DateTime? date) {
    _licenseIssueDate = date;
    notifyListeners();
  }

  set licenseExpiryDate(DateTime? date) {
    _licenseExpiryDate = date;
    notifyListeners();
  }

  set showLicenseFields(bool value) {
    _showLicenseFields = value;
    notifyListeners();
  }

  set selectedServices(List<Service> services) {
    _selectedServices = services;
    notifyListeners();
  }

  set licenseFrontImage(File? image) {
    _licenseFrontImage = image;
    notifyListeners();
  }

  set licenseBackImage(File? image) {
    _licenseBackImage = image;
    notifyListeners();
  }

  //TextEditingControllers
  late TextEditingController therapistNameController;
  late TextEditingController therapistQualificationController;
  late TextEditingController certificationController;
  late TextEditingController licenseNumberController;
  late TextEditingController contactNumberController;

  //License Fields
  late TextEditingController issuingAuthorityController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  String? _country;
  String? _state;

  // Getters
  String? get country => _country;
  String? get state => _state;

  // Setters
  set country(String? value) {
    _country = value;
    notifyListeners();
  }

  set state(String? value) {
    _state = value;
    notifyListeners();
  }

  void initialize() {
    therapistNameController = TextEditingController();
    therapistQualificationController = TextEditingController();
    certificationController = TextEditingController();
    licenseNumberController = TextEditingController();
    contactNumberController = TextEditingController();
    issuingAuthorityController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
  }

  void toggleService(Service service) {
    if (_selectedServices.contains(service)) {
      _selectedServices.remove(service);
    } else {
      _selectedServices.add(service);
    }
    notifyListeners();
  }

  List<Service> services = [
    Service(
      name: AppStrings.therapistOnSite,
      pngPath: 'lib/assets/images/therapist.png',
    ),
    Service(
        name: AppStrings.onCallNurse,
        pngPath: 'lib/assets/images/call_icon.png'),
    Service(
        name: AppStrings.physicalTherapy,
        pngPath: 'lib/assets/images/psychologist.png'),
    Service(
      name: AppStrings.rehabilitation,
      pngPath: 'lib/assets/images/rehabilitation.png',
    ),
    Service(
      name: AppStrings.hospicare,
      pngPath: 'lib/assets/images/doc.png',
    ),
  ];

  void pickFrontImage() async {
    var pickedFile = await FilePickerService.selectAndCropImage();
    if (pickedFile != null) {
      licenseFrontImage = pickedFile;
    }
  }

  void pickBackImage() async {
    var pickedFile = await FilePickerService.selectAndCropImage();
    if (pickedFile != null) {
      licenseBackImage = pickedFile;
    }
  }

  void registerProfessional() {}

  @override
  void dispose() {
    therapistNameController.dispose();
    therapistQualificationController.dispose();
    certificationController.dispose();
    licenseNumberController.dispose();
    contactNumberController.dispose();
    issuingAuthorityController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }
}
