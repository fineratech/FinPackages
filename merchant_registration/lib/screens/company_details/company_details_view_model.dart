import 'dart:io';

import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CompanyDetailsViewModel extends ChangeNotifier {
  CompanyDetailsViewModel() {
    initialize();
  }

  bool _isIndividual = true;
  String? _country;
  String? _state;
  String? _city;
  File? _image;
  AddressCategory _addressCategory = AddressCategory.headquarter;
  AddressSubCategory _addressSubCategory = AddressSubCategory.commercial;
  final formKey = GlobalKey<FormBuilderState>();

  bool get isIndividual => _isIndividual;
  String? get country => _country;
  String? get state => _state;
  String? get city => _city;
  File? get image => _image;
  AddressCategory get addressCategory => _addressCategory;
  AddressSubCategory get addressSubCategory => _addressSubCategory;

  //TextEditing Controllers
  late TextEditingController merchantName;
  late TextEditingController streetLine1;
  late TextEditingController apartmentOrSuite;
  late TextEditingController zipCode;

  void initialize() {
    merchantName = TextEditingController();
    streetLine1 = TextEditingController();
    apartmentOrSuite = TextEditingController();
    zipCode = TextEditingController();
  }

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

  set addressCategory(AddressCategory category) {
    _addressCategory = category;
    notifyListeners();
  }

  set addressSubCategory(AddressSubCategory category) {
    _addressSubCategory = category;
    notifyListeners();
  }

  void pickImage() async {
    var pickedFile = await FilePickerService.selectAndCropImage();
    if (pickedFile != null) {
      image = pickedFile;
    }
  }

  @override
  void dispose() {
    merchantName.dispose();
    streetLine1.dispose();
    apartmentOrSuite.dispose();
    zipCode.dispose();
    super.dispose();
  }
}
