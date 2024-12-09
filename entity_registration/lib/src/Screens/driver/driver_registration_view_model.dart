import 'package:fin_api_functions/fin_api_functions.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:logger/logger.dart';

class  DriverRegistrationViewModel  extends ChangeNotifier{

  DriverRegistrationViewModel(){
    initialize();
    _apiFunctionsService = ApiFunctionsService(
      logger: logger,
    );
  }

//Services
final Logger logger = Logger();
late ApiFunctionsService _apiFunctionsService;

//Form
final formKey = GlobalKey<FormBuilderState>();


// variables 

String _driverId = ''; // by add_ at start of variable it become private field
IdType _idType = IdType.other;

String? _country;
  String? _state;
  String? _city;

DateTime ? _driverIdIssueDate ;
DateTime ? _driverIdExpiryDate ;

DateTime ? _licenseIssueDate ;
DateTime ? _licenseExpiryDate ;

IdType _driverIdType =IdType.other;

// getter


String? get country => _country;
  String? get state => _state;
  String? get city => _city;

String get driverId => _driverId;

IdType get idType => _idType; 

IdType get driverIdType => _driverIdType;

DateTime? get driverIdIssueDate => _driverIdIssueDate;

DateTime? get driverIdExpiryDate => _driverIdExpiryDate;
DateTime? get licenseIssueDate => _licenseIssueDate;
DateTime? get licenseExpiryDate => _licenseExpiryDate;



// setters


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

set driverId (String value){
  _driverId = value;

  notifyListeners();
}

set idType (IdType value){
  _idType = value;

  notifyListeners();
}

set driverIdType (IdType value){
  _driverIdType = value;

  notifyListeners();
}

set  driverIdIssueDate(DateTime? value){
  _driverIdIssueDate = value;
  notifyListeners();

}

set  driverIdExpiryDate(DateTime? value){
  _driverIdExpiryDate = value;
  notifyListeners();

}

set  licenseIssueDate(DateTime? value){
  _licenseIssueDate = value;
  notifyListeners();

}

set  licenseExpiryDate(DateTime? value){
  _licenseExpiryDate = value;
  notifyListeners();

}

  // controllers

late TextEditingController driverFirstName ;
late TextEditingController driverLastName ;
late TextEditingController driverUsername ;
late TextEditingController driverEmail ;
late TextEditingController driverPassword ;
late TextEditingController driverContactNumber ;
late TextEditingController driverIssuingAuthority ;
late TextEditingController driverIDType ;
late TextEditingController driverLicenseType ;
late TextEditingController driverLicenseCountry ;
late TextEditingController driverLicenseState ;
late TextEditingController driverLicenseNumber ;
late TextEditingController driverLicenseIssueDate ;
late TextEditingController driverLicenseExpirationDate ;
late TextEditingController driverIssueCategory ;
late TextEditingController driverTruckingCompanyId ;
late TextEditingController driverTypeId ;
late TextEditingController driverIdNumber ;



// intialize 

void initialize(){

driverFirstName = TextEditingController();
driverLastName = TextEditingController();
driverUsername = TextEditingController();
driverEmail = TextEditingController();
driverPassword = TextEditingController();
driverContactNumber = TextEditingController();
driverIssuingAuthority = TextEditingController();
driverIDType = TextEditingController();
driverLicenseType = TextEditingController();
driverLicenseCountry = TextEditingController();
driverLicenseState = TextEditingController();
driverLicenseNumber = TextEditingController();
driverLicenseIssueDate = TextEditingController();
driverLicenseExpirationDate = TextEditingController();
driverIssueCategory = TextEditingController();
driverTruckingCompanyId = TextEditingController();
driverTypeId = TextEditingController();
driverIdNumber = TextEditingController();


}

Future<bool> registerDriver({required String merchantId,
  required String userId,
  required EntityType type,
  required String locationId,})async{
   int driverId =  await _apiFunctionsService.registerDriver(userId, driverIssueCategory.text, type.name, driverTruckingCompanyId.text, idType.name, driverIdNumber.text, driverIdExpiryDate.toString(), driverIdIssueDate.toString(), country?? "-1", driverLicenseType.text, driverLicenseNumber.text, licenseExpiryDate.toString(), state?? "-1", country??"",);
   if(driverId==-1){
    //TODO: show error toast
    return false;
   }else{
    //TODO: show success toast
    return true;
   }
}

// dispose 

@override
  void dispose() {


    driverFirstName.dispose();
driverLastName.dispose();
driverUsername.dispose();
driverEmail.dispose();
driverPassword.dispose();
driverContactNumber.dispose();
driverIssuingAuthority.dispose();
driverIDType.dispose();
driverLicenseType.dispose();
driverLicenseCountry.dispose();
driverLicenseState.dispose();
driverLicenseNumber.dispose();
driverLicenseIssueDate.dispose();
driverLicenseExpirationDate.dispose();
driverIssueCategory.dispose();
driverTruckingCompanyId.dispose();
driverTypeId.dispose();
driverIdNumber.dispose();

    
    super.dispose();


  }





}