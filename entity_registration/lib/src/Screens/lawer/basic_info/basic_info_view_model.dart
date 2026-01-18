import 'package:fin_api_functions/fin_api_functions.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:logger/logger.dart';

class BasicInfoViewModel extends ChangeNotifier {
  BasicInfoViewModel({required this.merchantId}) {
    initialize();
  }
  late ApiFunctionsService _apiFunctionsService;
  final Logger logger = Logger();

  final String merchantId;

  //Form Key
  final formKey = GlobalKey<FormBuilderState>();

  // Fields
  Gender? _selectedGender = Gender.male;
  DateTime? _dateOfBirth;
  List<ServiceModel>? _allServices;
  List<ServiceModel> _selectedServices = [];
  bool _isLoading = false;
  bool _isError = false;

  // Getters
  Gender? get selectedGender => _selectedGender;
  DateTime? get dateOfBirth => _dateOfBirth;
  bool get isLoading => _isLoading;
  bool get isError => _isError;

  List<ServiceModel>? get allServices => _allServices;
  List<ServiceModel> get selectedServices => _selectedServices;

  // Setters
  set selectedGender(Gender? gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  set dateOfBirth(DateTime? date) {
    _dateOfBirth = date;
    notifyListeners();
  }

  set selectedServices(List<ServiceModel> services) {
    _selectedServices = services;
    notifyListeners();
  }

  set allServices(List<ServiceModel>? services) {
    _allServices = services;
    notifyListeners();
  }

  set isLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  set isError(bool error) {
    _isError = error;
    notifyListeners();
  }

  //TextEditingControllers
  late TextEditingController lawerNameController;
  late TextEditingController lawerDescriptionController;
  late TextEditingController lawerQualificationController;
  late TextEditingController certificationController;
  late TextEditingController contactNumberController;

  void initialize() {
    _apiFunctionsService = ApiFunctionsService(
      logger: logger,
    );
    lawerNameController = TextEditingController();
    lawerDescriptionController = TextEditingController();
    lawerQualificationController = TextEditingController();
    certificationController = TextEditingController();
    contactNumberController = TextEditingController();
    getServices();
  }

  Future<void> getServices() async {
    isLoading = true;
    final response =
        await _apiFunctionsService.getAllAvailableServicesByCategory('legal');
    if (response != null) {
      isError = false;
      allServices = response;
    } else {
      isError = true;
    }
    isLoading = false;
  }

  void toggleService(ServiceModel service) {
    if (_selectedServices.contains(service)) {
      _selectedServices.remove(service);
    } else {
      _selectedServices.add(service);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    lawerNameController.dispose();
    lawerQualificationController.dispose();
    certificationController.dispose();
    lawerDescriptionController.dispose();
    contactNumberController.dispose();

    super.dispose();
  }
}
