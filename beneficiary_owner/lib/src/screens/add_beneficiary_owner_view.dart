// import 'dart:convert';

import 'package:beneficiary_owner/src/screens/add_beneficiary_owner_view_model.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:truckload/API_funcs.dart';
// import 'package:truckload/config.dart';
// import 'package:truckload/global_variables.dart';
// import 'package:truckload/models/user_registration_model.dart';
// import 'package:truckload/res/Themes/custom_theme/app_colors.dart';
// import 'package:truckload/res/components/ReusableWidgets/DropdownButtonFormField.dart';
// import 'package:truckload/res/components/ReusableWidgets/Sizedbox.dart';
// import 'package:truckload/res/components/ReusableWidgets/TextformFeild.dart';
// import 'package:truckload/res/components/ReusableWidgets/custome_button.dart';
// import 'package:truckload/res/components/widgets/RegisterCompanyWidgets/RegisterIndividualCheckMarks.dart';
// import 'package:truckload/res/constants/Strings.dart';
// import 'package:truckload/utils/Routes/routes_name.dart';
// import 'package:truckload/view/SignUp.dart';

class BeneficiaryOwner extends StatelessWidget {
  const BeneficiaryOwner({super.key, this.payFacs = const []});
  final List<PayFacsResult>? payFacs;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=> AddBeneficiaryOwnerViewModel(),
      builder: (context,_) {
        return Consumer<AddBeneficiaryOwnerViewModel>(
          builder: (context,viewModel,_) {
            return Scaffold(
              appBar: const CustomAppBar(title: 'Add Beneficiary Owner'),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: Column(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 60.0, right: 60),
                      //   child: RegisterIndividualCheckMarks(
                      //     FirstcheckMarkIconColor: true,
                      //     FirstVertColor: true,
                      //     SecondcheckMarkIconColor: true,
                      //     SecondVertColor: true,
                      //     ThirdcheckMarkIconColor: true,
                      //     ThirdVertColor: true,
                      //     FourthcheckMarkIconColor: true,
                      //   ),
                      // ),
                      const SizedBox(height: 20,),
                      CustomTextField(name: 'percentage', label: 'Percentage',controller: viewModel.percentageOwnerController,),
                     
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(name: 'firstName', label: 'First Name', controller: viewModel.firstNameController,)
                            
                          ),
                          const SizedBox(width: 5,),
                          
                          Expanded(
                            child:
                            CustomTextField(name: 'lastName', label:  'Last Name ', controller:  viewModel.lastNameController,),
                            
                        
                          ),
                        ],
                      ),

                      const SizedBox(height: 15,),
                      
                      Row(
                        children: [
                          Expanded(
                            child:
                            CustomTextField(name: 'SSN', label: 'SSN', controller: viewModel.snnController,)
                            
                            
                          ),

                          const SizedBox(width: 5,),
                          
                          Expanded(
                            child: 
                            CustomDatePicker(name: 'dob', label: "Date of birth",onChanged: (date) {
                              viewModel.dateOfBirth =date;
                            },),
                            
                            
                          ),
                        ],
                      ),

                      const SizedBox(height: 20,),
                      CustomTextField(name: 'Email',label: 'Email',controller: viewModel.emailController,),
                      
                      const SizedBox(height: 20,),
                      CustomTextField(name: 'phoneNumber' , label: 'Phone Number', controller: viewModel.phoneNumberController,),
                      
                      const SizedBox(height: 20,),

                      CustomTextField(name: 'phoneNumberEXT', label: 'Phone Numebr EXT', controller: viewModel.phoneNumberExtController,),
                     
                      const SizedBox(height: 20,),
                      
                      CustomTextField(name: 'faxNumber' , label: 'Fax Number', controller: viewModel.faxNumberController,),
                       const SizedBox(height: 20,),
                      
                      CustomTextField(name: 'address' , label: 'Address', controller: viewModel.addressController,),
                      
                       const SizedBox(height: 20,),
                      
                      Row(
                        children: [
                          Expanded(
                            child: 
                            
                            CustomTextField(name: 'apt', label: 'Apt', controller: viewModel.aptController,)
                            
                          ),

                          const SizedBox(width: 5,),
                         
                          Expanded(
                            child:
                            
                            CustomTextField(name: 'city', label: 'City', controller: viewModel.cityController,),
                             
                          ),
                        ],
                      ),

                      const SizedBox(height: 20,),
                      
                      Row(
                        children: [
                          Expanded(
                            child: 
                            CustomTextField(name: 'state',label: 'State', controller: viewModel.stateController,)
                            
                          ),

                          const SizedBox(width: 5,),
                          
                          Expanded(
                            child:
                            
                            CustomTextField(name: 'country' , label: 'Country', controller: viewModel.countryController,)
                            
                             
                          ),
                        ],
                      ),

                      const SizedBox(height: 20,),
                      
                      Row(
                        children: [
                          Expanded(
                            child: 
                            CustomTextField(name: 'postalCode',label: 'Postal Code', controller: viewModel.postalCodeController,),
                            
                            
                          ),
                          const SizedBox(width: 5,),
                          Expanded(
                            child:
                            CustomTextField(name: 'postalCodeExtension' , label: 'Postal Code Extension', controller: viewModel.postalCodeExtensionController,)
                            
                            
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(
                            child: 
                            
                            CustomTextField(name: 'id', label: 'ID', controller: viewModel.idController,)
                            
                            
                          ),

                          const SizedBox(width: 5,),
                         
                          Expanded(
                            child: CustomDropdownField(name: 'type',initialValue: viewModel.selectedBeneficiaryType, items: ['LLC', 'TruckLoad'].map((item)=> DropdownMenuItem(child: Text(item))).toList(),onChanged: (val) {
                              viewModel.selectedBeneficiaryType = val;
                            },)
                            
                             
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),

                      CustomTextField(name: 'issuedState', label: 'Issued State', controller: viewModel.issuedStateController,),
                      
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(
                            child: 
                            
                            CustomTextField(name: 'issuedCountry', label: 'Issued Country' , controller: viewModel.issuedCountryController,),
                            
                            
                          ),
                          const SizedBox(width: 5,),
                          Expanded(
                            child: 
                            
                            CustomTextField(name: 'issuedCity', label: 'Isssued City', controller: viewModel.issuedCityController,),
                            
                            
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(
                            child: CustomDatePicker(name: 'issueDate', label: "Issue Date", onChanged: (date) {
                              viewModel.issueDate= date;
                            },)
                            
                           
                          ),
                         const SizedBox(width: 5,),
                          Expanded(
                            child: CustomDatePicker(name: 'expiryDate',label: 'Expiry Date ', onChanged: (date) {
                              viewModel.expiryDate = date;
                            },)                            
                            
                          ),
                        ],
                      ),
                     const SizedBox(height: 60,),
                      const Row(
                        children: [
                           Icon(Icons.camera_alt),
                           SizedBox(width: 20,),
                           Text('Add Picture'),
                        ],
                      ),
                      const SizedBox(height: 60,),
                      CustomButton(
                        child: const Text("Add"),
                        onPressed: () {
                          //  splitDOB();
                          // splitIssuedDate();
                          // splitExpiryDate();
                         
                          // registerOwner(idController.text.toString(), PayFac.toString(), BeneficiaryOwnerTitle, title, firstNameController.text.toString(), "", lastNameController.text.toString(), phoneNumberController.text.toString(), PhoneNumberExtController.text.toString(), FaxNumberController.text.toString(), emailController.text.toString(), percentageOwnerController.text.toString(), SSNController.text.toString(), day.toString(), month.toString(), year.toString(), addressController.text.toString(), AptController.text.toString(), CityController.text.toString(), StateController.text.toString(), CountryController.text.toString(), postalCodeController.text.toString(), postalCodeExtensionController.text.toString());
                          // generate_password();
                          // owner_Id = loggedInUser_Global.userId;
                          // registerUserWithPhoneNumberGolden(emailController.text.toString(), password.toString(), firstNameController.text.toString(), lastNameController.text.toString(), phoneNumberController.text.toString(), context);
                          // registerOwnersIssuedIdentity(owner_Id.toString(), PayFac.toString(), selectedBeneficiaryType.toString(), idController.text.toString(), IssuedCityController.text.toString(), IssuedStateController.text.toString(), IssuedCountryController.text.toString(), issue_year.toString(), issue_month.toString(), issue_day.toString(), expiry_year.toString(), expiry_month.toString(), expiry_day.toString());
            
                          // Navigator.pushNamed(
                          //     context, RoutesNames.beneficiaryOwnerThankYou);
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        );
      }
    );
  }
}

