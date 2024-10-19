import 'package:entity_registration/src/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../enums/gender.dart';
import '../../models/service.dart';

class RegisterTherapistViewModel extends ChangeNotifier {
  RegisterTherapistViewModel() {
    initialize();
  }
  //Form Key
  final formKey = GlobalKey<FormBuilderState>();

  // Fields
  Gender? _selectedGender;
  DateTime? _dateOfBirth;
  bool _showLicenseFields = false;
  List<Service> _selectedServices = [];

  // Getters
  Gender? get selectedGender => _selectedGender;
  DateTime? get dateOfBirth => _dateOfBirth;
  bool get showLicenseFields => _showLicenseFields;
  List<Service> get selectedServices => _selectedServices;

  // Setters
  set selectedGender(Gender? gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  set dateOfBirth(DateTime? date) {
    _dateOfBirth = date;
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

  //TextEditingControllers
  late TextEditingController therapistNameController;
  late TextEditingController therapistQualificationController;
  late TextEditingController certificationController;

  void initialize() {
    therapistNameController = TextEditingController();
    therapistQualificationController = TextEditingController();
    certificationController = TextEditingController();
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

  @override
  void dispose() {
    therapistNameController.dispose();
    therapistQualificationController.dispose();
    certificationController.dispose();
    super.dispose();
  }
}
