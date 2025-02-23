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

  IdType? _idType = IdType.passport;
  OwnerType? _ownerType = OwnerType.beneficiary;

  bool _isLoading = false;

  String? _country;
  String? _state;
  String? _city;

  String? _idIssueCountry;
  String? _idIssueState;
  String? _idIssueCity;

  //Form Key
  final formKey = GlobalKey<FormBuilderState>();

  //Getters
  DateTime? get dateOfBirth => _dateOfBirth;

  DateTime? get issueDate => _issueDate;

  DateTime? get expiryDate => _expiryDate;

  IdType? get idType => _idType;
  OwnerType? get ownerType => _ownerType;
  bool get isLoading => _isLoading;

  String? get country => _country;
  String? get state => _state;
  String? get city => _city;
  String? get idIssueCountry => _idIssueCountry;
  String? get idIssueState => _idIssueState;
  String? get idIssueCity => _idIssueCity;

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

  set idIssueCountry(String? value) {
    _idIssueCountry = value;
    notifyListeners();
  }

  set idIssueState(String? value) {
    _idIssueState = value;
    notifyListeners();
  }

  set idIssueCity(String? value) {
    _idIssueCity = value;
    notifyListeners();
  }

  //Controllers
  late TextEditingController percentageOwnerController;
  late TextEditingController firstNameController;
  late TextEditingController middleNameController;
  late TextEditingController lastNameController;
  late TextEditingController snnController;
  late TextEditingController addressController;
  late TextEditingController idController;
  // late TextEditingController issuedStateController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController phoneNumberExtController;
  late TextEditingController faxNumberController;
  late TextEditingController aptController;
  // late TextEditingController cityController;
  // late TextEditingController stateController;
  // late TextEditingController countryController;
  late TextEditingController postalCodeController;
  late TextEditingController postalCodeExtensionController;
  // late TextEditingController issuedCountryController;
  // late TextEditingController issuedCityController;

  void initialize() {
    percentageOwnerController = TextEditingController();
    firstNameController = TextEditingController();
    middleNameController = TextEditingController();
    lastNameController = TextEditingController();
    snnController = TextEditingController();
    addressController = TextEditingController();
    idController = TextEditingController();
    // issuedStateController = TextEditingController();
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();
    phoneNumberExtController = TextEditingController();
    faxNumberController = TextEditingController();
    aptController = TextEditingController();
    // cityController = TextEditingController();
    // stateController = TextEditingController();
    // countryController = TextEditingController();
    postalCodeController = TextEditingController();
    postalCodeExtensionController = TextEditingController();
    // issuedCountryController = TextEditingController();
    // issuedCityController = TextEditingController();
  }

  Future<bool> addBeneficiaryOwner(BuildContext context, String merchantId,
      String merchantPayFacDbId) async {
    isLoading = true;
    try {
      String? ownerId = await _apiFunctionsService.registerOwner(
        merchantId,
        merchantPayFacDbId,
        ownerType?.value ??
            "beneficialowner", // beneficial owner, control owner
        "Principal",
        firstNameController.text,
        lastNameController.text,
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
        aptController
            .text, // Populate this value from the screen. If the apt controller dont have the addressline2 for the apt or suite number, send in "NA"
        city ?? '-1',
        state ?? '-1',
        country ?? '-1',
        postalCodeController.text,
        postalCodeExtensionController.text,
      );

      if (ownerId != null) {
        try {
          await _apiFunctionsService.registerOwnersIssuedIdentity(
            ownerId,
            merchantPayFacDbId,
            idType?.name ?? 'other',
            idController.text,
            idIssueCity ?? '-1',
            idIssueState ?? '-1',
            idIssueCountry ?? '-1',
            issueDate!.year.toString(),
            issueDate!.month.toString(),
            issueDate!.day.toString(),
            expiryDate!.year.toString(),
            expiryDate!.month.toString(),
            expiryDate!.day.toString(),
          );
        } catch (e) {
          if (context.mounted) {
            Utils.showErrorToast(
              context: context,
              message: "Failed to register Owner's Issued Identity",
            );
          }
          isLoading = false;
        }
      }

      if (context.mounted) {
        Utils.showSuccessToast(
          context: context,
          message: "Beneficiary Owner Added Successfully",
        );
      }

      isLoading = false;
      return true;
    } catch (e) {
      isLoading = false;
    }
    return true;
  }

  @override
  void dispose() {
    percentageOwnerController.dispose();
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    snnController.dispose();
    addressController.dispose();
    idController.dispose();
    // issuedStateController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    phoneNumberExtController.dispose();
    faxNumberController.dispose();
    aptController.dispose();
    // cityController.dispose();
    // stateController.dispose();
    // countryController.dispose();
    postalCodeController.dispose();
    postalCodeExtensionController.dispose();
    // issuedCountryController.dispose();
    // issuedCityController.dispose();
    super.dispose();
  }
}
