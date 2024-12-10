import 'package:entity_registration/src/Screens/truck/truck_registration_view_model.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
class RegisterTruck extends StatelessWidget {
  const RegisterTruck({super.key, required this.onDone, required this.merchantId, required this.userId, required this.type, required this.locationId});
  final void Function(dynamic) onDone;
  final String merchantId;
  final String userId;
  final EntityType type;
  final String locationId;

@override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TruckRegistrationViewModel(),
      builder: (context,_) {
        return Consumer<TruckRegistrationViewModel>(
          builder: (context,viewModel,_) {
            return Scaffold(
             // appBar: 
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 8),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(left: 60.0,right: 60),
                      //   child: RegisterIndividualCheckMarks(FirstcheckMarkIconColor: true,FirstVertColor:true,SecondcheckMarkIconColor: true,SecondVertColor: true,),
                      // ),
                     const  SizedBox(height: 20,),
                      CustomTextField(name: 'ownerId', label: 'Owner ID',controller: viewModel.TruckOwnerID,),
                      const  SizedBox(height: 20,),
                      
                      CustomDropdownField(
                        name: 'truckType',
                        initialValue: viewModel.truckType,
                        items: ['Carry','Load']
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          viewModel.truckType = val;
                        },
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(),
                          ],
                        ),
                      ),
                      const  SizedBox(height: 20,),
                      CustomTextField(name: 'idType', label: 'Id Type', controller: viewModel.TruckIDType,),
                      const  SizedBox(height: 20,),

                      CustomDropdownField(
                        name: 'truckModel',
                        initialValue: viewModel.truckModel,
                        items: ['2020','2030']
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          viewModel.truckModel = val;
                        },
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(),
                          ],
                        ),
                      ),
                      const  SizedBox(height: 20,),

                      CustomTextField(name: 'registrationNumber', label: 'Registration Number', controller: viewModel.TruckRegNumber,),

                      const  SizedBox(height: 20,),

                      CustomTextField(name: 'plateNumber', label: 'Plate Number', controller: viewModel.TruckPlateNumber,),

                      const  SizedBox(height: 20,),
                      
                      CustomTextField(name: 'portName', label: 'Port Name', controller: viewModel.TruckPortName,),

                      const  SizedBox(height: 20,),

                      

                       CustomDropdownField(
                        name: 'truckCategory',
                        initialValue: viewModel.category,
                        items: ['New','Old']
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          viewModel.category = val;
                        },
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(),
                          ],
                        ),
                      ),
                      const  SizedBox(height: 20,),
                      
                      CustomDropdownField(
                        name: 'truckCompanyID',
                        initialValue: viewModel.category,
                        items: ['980','883']
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          viewModel.category = val;
                        },
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(),
                          ],
                        ),
                      ),
                      const  SizedBox(height: 20,),

                      CustomDropdownField(
                        name: 'truckMake',
                        initialValue: viewModel.category,
                        items: ['Passengers','Make']
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          viewModel.truckMake = val;
                        },
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(),
                          ],
                        ),
                      ),
                      const  SizedBox(height: 20,),

                      CustomTextField(name: 'year', label: 'Year', controller: viewModel.TruckYear,),
                      const  SizedBox(height: 20,),


                      CustomDropdownField(
                        name: 'truckLength',
                        initialValue: viewModel.category,
                        items: ['8m','10m']
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          viewModel.truckLength = val;
                        },
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(),
                          ],
                        ),
                      ),
                      const  SizedBox(height: 20,),
                      CustomTextField(name: 'registrationValidity' , label: 'Registration Validity', controller: viewModel.TruckRegValidity,),

                      const  SizedBox(height: 20,),
                      CustomTextField(name: 'insuranceValidity', label: 'Insurance Validity', controller: viewModel.TruckInsuranceValidity,),
                      
                      const  SizedBox(height: 20,),
                      CustomTextField(name: 'portNumber' , label: 'Port Number', controller: viewModel.TruckPortNumber,),
                      
                      const  SizedBox(height: 40,),

                      const CustomButton(
                        child: Text('Next'),
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
