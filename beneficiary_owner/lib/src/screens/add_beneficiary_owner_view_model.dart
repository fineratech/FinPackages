import 'package:fin_api_functions/fin_api_functions.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:logger/logger.dart';

class AddBeneficiaryOwnerViewModel extends ChangeNotifier {
  AddBeneficiaryOwnerViewModel() {
    initialize();
  }

  //Services
  final Logger logger = Logger();
  final ApiFunctionsService _apiFunctionsService = ApiFunctionsService(
    logger: Logger(),
  );

  //Variables
  DateTime? _dateOfBirth;

  DateTime? _issueDate;

  DateTime? _expiryDate;

  IdType? _idType;
  OwnerType? _ownerType;

  bool _isLoading = false;

  //Form Key
  final formKey = GlobalKey<FormBuilderState>();

  //Getters
  DateTime? get dateOfBirth => _dateOfBirth;

  DateTime? get issueDate => _issueDate;

  DateTime? get expiryDate => _expiryDate;

  IdType? get idType => _idType;
  OwnerType? get ownerType => _ownerType;
  bool get isLoading => _isLoading;

  //Setters
  set dateOfBirth(DateTime? value) {
    _dateOfBirth = value;
    notifyListeners();
  }

  set issueDate(DateTime? value) {
    _issueDate = value;
    notifyListeners();
  }

  set expiryDate(DateTime? value) {
    _expiryDate = value;
    notifyListeners();
  }

  set idType(IdType? value) {
    _idType = value;
    notifyListeners();
  }

  set ownerType(OwnerType? value) {
    _ownerType = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //Controllers
  late TextEditingController percentageOwnerController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController snnController;
  late TextEditingController addressController;
  late TextEditingController idController;
  late TextEditingController issuedStateController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController phoneNumberExtController;
  late TextEditingController faxNumberController;
  late TextEditingController aptController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController countryController;
  late TextEditingController postalCodeController;
  late TextEditingController postalCodeExtensionController;
  late TextEditingController issuedCountryController;
  late TextEditingController issuedCityController;

  void initialize() {
    percentageOwnerController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    snnController = TextEditingController();
    addressController = TextEditingController();
    idController = TextEditingController();
    issuedStateController = TextEditingController();
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();
    phoneNumberExtController = TextEditingController();
    faxNumberController = TextEditingController();
    aptController = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    countryController = TextEditingController();
    postalCodeController = TextEditingController();
    postalCodeExtensionController = TextEditingController();
    issuedCountryController = TextEditingController();
    issuedCityController = TextEditingController();
  }

  Future<bool> addBeneficiaryOwner(BuildContext context, String merchantId,
      String merchantPayFacDbId) async {
    isLoading = true;
    try {
      String ownerId = await _apiFunctionsService.registerOwner(
        merchantId,
        merchantPayFacDbId,
        ownerType?.name ?? "beneficialowner", // beneficial owner, control owner
        "Principal",
        firstNameController.text,
        "",
        lastNameController.text,
        phoneNumberController.text,
        phoneNumberExtController.text,
        faxNumberController.text,
        emailController.text,
        percentageOwnerController.text,
        snnController.text,
        dateOfBirth!.year.toString(),
        dateOfBirth!.month.toString(),
        dateOfBirth!.day.toString(),
        addressController.text,
        aptController.text, // Populate this value from the screen. If the apt controller dont have the addressline2 for the apt or suite number, send in "NA"
        cityController.text,
        stateController.text,
        countryController.text,
        postalCodeController.text,
        postalCodeExtensionController.text,
      );

      await _apiFunctionsService.registerOwnersIssuedIdentity(
        ownerId,
        merchantPayFacDbId,
        idType?.name ?? 'other',
        idController.text,
        issuedCityController.text,
        issuedStateController.text,
        issuedCountryController.text,
        issueDate!.year.toString(),
        issueDate!.month.toString(),
        issueDate!.day.toString(),
        expiryDate!.year.toString(),
        expiryDate!.month.toString(),
        expiryDate!.day.toString(),
      );

      if (context.mounted) {
        Utils.showSuccessToast(
          context: context,
          message: "Beneficiary Owner Added Successfully",
        );
      }

      isLoading = false;
      return true;
    } catch (e) {
      if (context.mounted) {
        Utils.showErrorToast(
          context: context,
          message: "Failed to add Beneficiary Owner",
        );
      }
      isLoading = false;
    }
    return false;
  }

  @override
  void dispose() {
    percentageOwnerController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    snnController.dispose();
    addressController.dispose();
    idController.dispose();
    issuedStateController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    phoneNumberExtController.dispose();
    faxNumberController.dispose();
    aptController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    postalCodeController.dispose();
    postalCodeExtensionController.dispose();
    issuedCountryController.dispose();
    issuedCityController.dispose();
    super.dispose();
  }
}
