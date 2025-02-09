import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:entity_registration/src/Screens/driver/driver_registration_view_model.dart';
import 'package:entity_registration/src/constants/app_colors.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class RegisterDriver extends StatelessWidget {
  const RegisterDriver(
      {super.key,
      required this.onDone,
      required this.userId,
      required this.merchantId,
      required this.type,
      required this.locationId});
  final void Function(dynamic) onDone;
  final String merchantId;
  final String userId;
  final EntityType type;
  final String locationId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => DriverRegistrationViewModel(),
        builder: (context, _) {
          return Consumer<DriverRegistrationViewModel>(
              builder: (context, viewModel, _) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
              child: SingleChildScrollView(
                child: FormBuilder(
                  key: viewModel.formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        name: 'firstName',
                        label: 'First Name',
                        controller: viewModel.driverFirstName,
                        validator: FormBuilderValidators.required(),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      CustomTextField(
                          name: 'lastName',
                          label: 'Last Name',
                          controller: viewModel.driverLastName,
                          validator: FormBuilderValidators.required()),

                      const SizedBox(
                        height: 20,
                      ),

                      CustomTextField(
                          name: 'userName',
                          label: 'User Name',
                          controller: viewModel.driverUsername,
                          validator: FormBuilderValidators.required()),

                      const SizedBox(
                        height: 20,
                      ),

                      CustomTextField(
                          name: 'email',
                          label: 'Email',
                          controller: viewModel.driverEmail,
                          validator: FormBuilderValidators.required()),

                      const SizedBox(
                        height: 20,
                      ),

                      CustomTextField(
                          name: 'password',
                          label: 'Password',
                          controller: viewModel.driverPassword,
                          validator: FormBuilderValidators.required()),

                      const SizedBox(
                        height: 20,
                      ),

                      CustomTextField(
                          name: 'contact',
                          label: 'Contact',
                          controller: viewModel.driverContactNumber,
                          validator: FormBuilderValidators.required()),

                      const SizedBox(
                        height: 20,
                      ),

                      CSCPickerPlus(
                        layout: Layout.horizontal,
                        flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                        currentCountry: viewModel.country,
                        currentState: viewModel.state,
                        currentCity: viewModel.city,
                        countryDropdownLabel: viewModel.country ?? 'Country',
                        defaultCountry: CscCountry.United_States,
                        onCountryChanged: (value) {
                          viewModel.country = value;
                        },
                        onStateChanged: (value) {
                          viewModel.state = value;
                        },
                        onCityChanged: (value) {
                          viewModel.city = value;
                        },
                        selectedItemStyle: const TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      // CustomRadioButtons(), //TODO: make a widget for radio buttons (active, in-active)

                      const SizedBox(
                        height: 20,
                      ),
                      const Row(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Icon(Icons.add_circle, color: Colors.blue),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Add Driver License',
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 75,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Row(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.document_scanner_outlined,
                                  color: Colors.black,
                                  size: 35,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text('Scan License'),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              'Register Driver OR',
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                          name: 'issue',
                          label: 'Issue',
                          controller: viewModel.driverIssueCategory,
                          validator: FormBuilderValidators.required()),

                      const SizedBox(
                        height: 20,
                      ),

                      CustomDropdownField(
                        name: 'idType',
                        initialValue: viewModel.idType,
                        items: IdType.values
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(item.name),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          viewModel.idType = val;
                        },
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(),
                          ],
                        ),
                      ),

                      // ReusableTextFormField(textFormFieldController: DriverIDType ,labelTxt: RegisterDriverIdType,),
                      const SizedBox(
                        height: 20,
                      ),

                      CustomTextField(
                          name: 'companyId',
                          label: 'Company Id',
                          controller: viewModel.driverTruckingCompanyId,
                          validator: FormBuilderValidators.required()),

                      const SizedBox(
                        height: 20,
                      ),
                      //VerticalSpace(15),

                      CustomDropdownField(
                        name: 'driverIdType',
                        initialValue: viewModel.driverIdType,
                        items: IdType.values
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(item.name),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          viewModel.idType = val;
                        },
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(),
                          ],
                        ),
                      ),

                      //ReusableTextFormField(textFormFieldController:DriverTypeId,labelTxt: RegisterDriverTypeID,),
                      //VerticalSpace(15),
                      const SizedBox(
                        height: 20,
                      ),

                      CustomTextField(
                          name: 'idNumber',
                          label: 'Id Number',
                          controller: viewModel.driverIdNumber,
                          validator: FormBuilderValidators.required()),

                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomDatePicker(
                              name: 'driverIdIssueDate',
                              label: 'Driver Id Issue Date',
                              inputType: InputType.date,
                              onChanged: (p0) {
                                viewModel.driverIdIssueDate = p0;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: CustomDatePicker(
                              name: 'driverIdExpiryDate',
                              label: 'Driver Id Expiry Date',
                              inputType: InputType.date,
                              onChanged: (p0) {
                                viewModel.driverIdExpiryDate = p0;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                          name: 'licenseType',
                          label: 'License Type',
                          controller: viewModel.driverLicenseType,
                          validator: FormBuilderValidators.required()),

                      const SizedBox(
                        height: 20,
                      ),

                      CustomTextField(
                          name: 'licenseNumber',
                          label: 'License Number',
                          controller: viewModel.driverLicenseNumber,
                          validator: FormBuilderValidators.required()),

                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomDatePicker(
                                name: 'licenseIssueDate',
                                label: 'License Issue Date',
                                inputType: InputType.date,
                                onChanged: (p0) {
                                  viewModel.licenseIssueDate = p0;
                                },
                                validator: FormBuilderValidators.required()),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: CustomDatePicker(
                                name: 'licenseExpiryDate',
                                label: 'License Expiry Date',
                                inputType: InputType.date,
                                onChanged: (p0) {
                                  viewModel.licenseExpiryDate = p0;
                                },
                                validator: FormBuilderValidators.required()),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      CustomTextField(
                          name: 'licenseCountry',
                          label: 'License Country',
                          controller: viewModel.driverLicenseCountry,
                          validator: FormBuilderValidators.required()),

                      const SizedBox(
                        height: 30,
                      ),
                      const Align(
                          alignment: Alignment.topLeft,
                          child: Text('Add Documents')),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey)),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cloud_upload,
                                      color: Colors.green,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text('Front Image'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey)),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cloud_upload,
                                      color: Colors.green,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text('Back Image'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey)),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.cloud_upload,
                                        color: Colors.green),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'National ID',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey)),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.cloud_upload,
                                        color: Colors.green),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text('Fitness Certificate'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey)),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.cloud_upload,
                                        color: Colors.green),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Passport',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey)),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.cloud_upload,
                                        color: Colors.green),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text('InternationalDriverPermit'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey)),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.cloud_upload,
                                        color: Colors.green),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text('CommericalDriverLicense'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Row(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Icon(
                            Icons.add_circle,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Add More Lisence')
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),

                      CustomButton(
                        child: const Text('Next'),
                        onPressed: () {
                          //  Navigator.pushNamed(context, RoutesNames.driverVehicleInfo);
                          viewModel
                              .registerDriver(
                                  context: context,
                                  userId: userId,
                                  merchantId: merchantId,
                                  type: type,
                                  locationId: locationId)
                              .then((value) {
                            if (value) {
                              onDone(_);
                            }
                          });

                          //registerDriver(driver_Id.toString(), DriverIssueCategory.text.toString(), SelectedDriverIdType.toString(), DriverTruckingCompanyId.text.toString(), SelectedIDType.toString(), DriverIdNumber.text.toString(), DriverIdExpiryDate.text.toString(), DriverIdIssueDate.text.toString(), DriverIdIssueCountry.text.toString(), DriverLicenseType.text.toString(), DriverLicenseNumber.text.toString(), DriverLicenseExpirationDate.text.toString(), DriverLicenseIssueDate.text.toString(), DriverLicenseCountry.text.toString());
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }
}
