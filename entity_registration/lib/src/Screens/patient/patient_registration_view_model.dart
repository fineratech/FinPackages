import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class PatientRegistrationViewModel extends ChangeNotifier {
  PatientRegistrationViewModel() {
    initialize();
  }

  //Form Key
  final formKey = GlobalKey<FormBuilderState>();

  // Fields
  Gender? _selectedGender;
  DateTime? _dateOfBirth;
  DateTime? _registrationDate;

  //TextEditingControllers
  late TextEditingController patientNameController;
  late TextEditingController locationController;

  // Getters
  Gender? get selectedGender => _selectedGender;
  DateTime? get dateOfBirth => _dateOfBirth;
  DateTime? get registrationDate => _registrationDate;

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

  void initialize() {
    patientNameController = TextEditingController();
    locationController = TextEditingController();
  }

  bool isFormValid() {
    return formKey.currentState?.saveAndValidate() ?? false;
  }

  @override
  void dispose() {
    patientNameController.dispose();
    locationController.dispose();
    super.dispose();
  }
}
