import 'package:flutter/material.dart';

class AddBeneficiaryOwnerViewModel extends ChangeNotifier{
  AddBeneficiaryOwnerViewModel(){
    initialize();
  }

  //Variables
  DateTime? _dateOfBirth;

  DateTime? _issueDate;


  DateTime? _expiryDate;

  String _selectedBeneficiaryType = 'LLC';

  String _password = '';

  String _ownerId = '';

  //Getters
  DateTime? get dateOfBirth => _dateOfBirth;

  DateTime? get issueDate => _issueDate;

  DateTime? get expiryDate => _expiryDate;


  String get selectedBeneficiaryType => _selectedBeneficiaryType;

  String get password => _password;

  String get ownerId => _ownerId;

  //Setters
  set dateOfBirth (DateTime? value){
    _dateOfBirth = value;
    notifyListeners();
  } 


  set issueDate (DateTime? value){
    _issueDate = value;
    notifyListeners();
  } 

  set expiryDate (DateTime? value){
    _expiryDate =value;
    notifyListeners();
  } 

  set selectedBeneficiaryType (String value){
    _selectedBeneficiaryType = value;
    notifyListeners();
  } 

  set password (String value){
    _password = value;
    notifyListeners();
  } 

  set ownerId (String value){
    _ownerId = value;
    notifyListeners();
  } 


  //Controllers
  late TextEditingController percentageOwnerController ;
  late TextEditingController firstNameController ;
  late TextEditingController lastNameController ;
  late TextEditingController snnController ;
  late TextEditingController addressController ;
  late TextEditingController idController ;
  late TextEditingController issuedStateController ;
  late TextEditingController emailController ;
  late TextEditingController phoneNumberController ;
  late TextEditingController phoneNumberExtController ;
  late TextEditingController faxNumberController ;
  late TextEditingController aptController ;
  late TextEditingController cityController ;
  late TextEditingController stateController ;
  late TextEditingController countryController ;
  late TextEditingController postalCodeController ;
  late TextEditingController postalCodeExtensionController ;
  late TextEditingController issuedCountryController ;
  late TextEditingController issuedCityController ;

  void initialize(){
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


  // String? PayFac; // Variable to hold the payFacTenancyId



//   void generate_password(){

// password = "${firstNameController.text.toString()}$month$year";
//   }


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