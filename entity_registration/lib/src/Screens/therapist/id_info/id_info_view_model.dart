import 'dart:io';

import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class IdInfoViewModel extends ChangeNotifier {
  IdInfoViewModel() {
    initialize();
  }
  //Form Key
  final formKey = GlobalKey<FormBuilderState>();

  DateTime? _idIssueDate;
  DateTime? _idExpiryDate;
  File? _idFrontImage;
  File? _idBackImage;
  IdType? _idType = IdType.passport;

  //License Fields
  late TextEditingController issuingAuthorityController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController idNumberController;
  String? _country;
  String? _state;
  String? _city;

  // Getters
  String? get country => _country;
  String? get state => _state;
  String? get city => _city;
  DateTime? get idIssueDate => _idIssueDate;
  DateTime? get idExpiryDate => _idExpiryDate;
  File? get idFrontImage => _idFrontImage;
  File? get idBackImage => _idBackImage;
  IdType? get idType => _idType;

  // Setters
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

  set idFrontImage(File? image) {
    _idFrontImage = image;
    notifyListeners();
  }

  set idBackImage(File? image) {
    _idBackImage = image;
    notifyListeners();
  }

  set idType(IdType? idType) {
    _idType = idType;
    notifyListeners();
  }

  void initialize() {
    issuingAuthorityController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    idNumberController = TextEditingController();
  }

  void pickFrontImage() async {
    var pickedFile = await FilePickerService.selectAndCropImage();
    if (pickedFile != null) {
      idFrontImage = pickedFile;
    }
  }

  void pickBackImage() async {
    var pickedFile = await FilePickerService.selectAndCropImage();
    if (pickedFile != null) {
      idBackImage = pickedFile;
    }
  }

  @override
  void dispose() {
    issuingAuthorityController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    idNumberController.dispose();
    super.dispose();
  }
}
