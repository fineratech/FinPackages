import 'dart:io';

import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';


class  TruckRegistrationViewModel  extends ChangeNotifier{


// variables 

String _category = '';
String _companyId = '';
String _truckModel = '';
String _truckLength = '';
String _truckType = '';
String _truckMake = '';


//getters
String get category => _category;
String get companyId => _companyId;
String get truckModel => _truckModel;
String get truckLength => _truckLength;
String get truckType => _truckType;
String get truckMake => _truckMake;


//setters

set category(String value){
  _category=value;
  notifyListeners();
}

set truckMake(String value){
  _truckMake=value;
  notifyListeners();
}

set truckType(String value){
  _truckType=value;
  notifyListeners();
}

set companyId(String value){
  _companyId=value;
  notifyListeners();
}

set truckModel(String value){
  _truckModel=value;
  notifyListeners();
}

set truckLength(String value){
  _truckLength=value;
  notifyListeners();
}

  // controllers

late TextEditingController TruckOwnerID ;
late TextEditingController TruckIDType ;
late TextEditingController TruckRegNumber ;
late TextEditingController TruckPlateNumber ;
late TextEditingController TruckPortNumber ;
late TextEditingController TruckYear ;
late TextEditingController TruckCategory ;
late TextEditingController TruckRegValidity ;
late TextEditingController TruckInsuranceValidity ;
late TextEditingController TruckPortName ;

//intialize 

void intialize(){

 TruckOwnerID = TextEditingController();
 TruckIDType = TextEditingController() ;
 TruckRegNumber = TextEditingController();
 TruckPlateNumber = TextEditingController();
 TruckPortNumber = TextEditingController();
 TruckYear = TextEditingController();
 TruckCategory = TextEditingController();
 TruckRegValidity = TextEditingController();
 TruckInsuranceValidity = TextEditingController();
 TruckPortName = TextEditingController();


}


// dispose
@override
  void dispose() {
TruckOwnerID.dispose();
 TruckIDType.dispose() ;
 TruckRegNumber.dispose();
 TruckPlateNumber.dispose();
 TruckPortNumber.dispose();
 TruckYear.dispose();
 TruckCategory.dispose();
 TruckRegValidity.dispose();
 TruckInsuranceValidity.dispose();
 TruckPortName.dispose();


    // TODO: implement dispose
    super.dispose();
  }
}