import 'dart:io';

import 'package:flutter/material.dart';
import 'package:merchant_registration/services/file_picker_service.dart';

class CompanyDetailsViewModel extends ChangeNotifier {
  bool _isIndividual = true;
  String? _country;
  String? _state;
  String? _city;
  File? _image;

  bool get isIndividual => _isIndividual;
  String? get country => _country;
  String? get state => _state;
  String? get city => _city;
  File? get image => _image;

  set isIndividual(bool value) {
    _isIndividual = value;
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

  set image(File? value) {
    _image = value;
    notifyListeners();
  }

  void pickImage() async {
    var pickedFile = await FilePickerService.selectAndCropImage();
    if (pickedFile != null) {
      image = pickedFile;
    }
  }
}
