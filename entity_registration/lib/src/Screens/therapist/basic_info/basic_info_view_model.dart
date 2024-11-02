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
  Gender? _selectedGender;
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
  late TextEditingController therapistNameController;
  late TextEditingController therapistQualificationController;
  late TextEditingController certificationController;
  late TextEditingController contactNumberController;

  void initialize() {
    _apiFunctionsService = ApiFunctionsService(
      logger: logger,
    );
    therapistNameController = TextEditingController();
    therapistQualificationController = TextEditingController();
    certificationController = TextEditingController();
    contactNumberController = TextEditingController();
    getServices();
  }

  Future<void> getServices() async {
    isLoading = true;
    final response =
        await _apiFunctionsService.getServiceByProviderId(merchantId);
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

  // List<Service> services = [
  //   Service(
  //     name: AppStrings.therapistOnSite,
  //     pngPath: 'lib/assets/images/therapist.png',
  //   ),
  //   Service(
  //       name: AppStrings.onCallNurse,
  //       pngPath: 'lib/assets/images/call_icon.png'),
  //   Service(
  //       name: AppStrings.physicalTherapy,
  //       pngPath: 'lib/assets/images/psychologist.png'),
  //   Service(
  //     name: AppStrings.rehabilitation,
  //     pngPath: 'lib/assets/images/rehabilitation.png',
  //   ),
  //   Service(
  //     name: AppStrings.hospicare,
  //     pngPath: 'lib/assets/images/doc.png',
  //   ),
  // ];

  @override
  void dispose() {
    therapistNameController.dispose();
    therapistQualificationController.dispose();
    certificationController.dispose();

    contactNumberController.dispose();

    super.dispose();
  }
}
