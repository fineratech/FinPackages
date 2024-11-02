import 'dart:io';

import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class LicenseInfoViewModel extends ChangeNotifier {
  LicenseInfoViewModel() {
    initialize();
  }
  //Form Key
  final formKey = GlobalKey<FormBuilderState>();

  DateTime? _licenseIssueDate;
  DateTime? _licenseExpiryDate;
  File? _licenseFrontImage;
  File? _licenseBackImage;

  //License Fields
  late TextEditingController issuingAuthorityController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController licenseNumberController;
  late TextEditingController licenseTypeController;
  String? _country;
  String? _state;

  // Getters
  String? get country => _country;
  String? get state => _state;
  DateTime? get licenseIssueDate => _licenseIssueDate;
  DateTime? get licenseExpiryDate => _licenseExpiryDate;
  File? get licenseFrontImage => _licenseFrontImage;
  File? get licenseBackImage => _licenseBackImage;

  // Setters
  set country(String? value) {
    _country = value;
    notifyListeners();
  }

  set state(String? value) {
    _state = value;
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

  set licenseFrontImage(File? image) {
    _licenseFrontImage = image;
    notifyListeners();
  }

  set licenseBackImage(File? image) {
    _licenseBackImage = image;
    notifyListeners();
  }

  void initialize() {
    issuingAuthorityController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    licenseNumberController = TextEditingController();
    licenseTypeController = TextEditingController();
  }

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

  @override
  void dispose() {
    issuingAuthorityController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    licenseNumberController.dispose();
    licenseTypeController.dispose();
    super.dispose();
  }
}
