// import 'dart:convert';

import 'package:beneficiary_owner/src/screens/add_beneficiary_owner_view_model.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class AddBeneficiaryOwnerView extends StatelessWidget {
  const AddBeneficiaryOwnerView({
    super.key,
    required this.merchantPayFacDbId,
    required this.onDone,
    required this.merchantId,
  });
  final String merchantPayFacDbId;
  final String merchantId;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => AddBeneficiaryOwnerViewModel(),
        builder: (context, _) {
          return Consumer<AddBeneficiaryOwnerViewModel>(
              builder: (context, viewModel, _) {
            return ModalProgressHUD(
              inAsyncCall: viewModel.isLoading,
              child: Scaffold(
                appBar: CustomAppBar(
                  title: 'Add Beneficiary Owner',
                  actions: [
                    TextButton(
                      onPressed: () {
                        onDone();
                      },
                      child: const Text("Skip"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 20),
                    child: FormBuilder(
                      key: viewModel.formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          CustomDropdownField(
                            name: 'ownerType',
                            initialValue: viewModel.ownerType,
                            items: OwnerType.values
                                .map(
                                  (val) => DropdownMenuItem(
                                    value: val,
                                    child: Text(val.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) {
                              viewModel.idType = val;
                            },
                            validator: FormBuilderValidators.required(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            name: 'percentage',
                            label: 'Percentage',
                            textInputType: TextInputType.number,
                            controller: viewModel.percentageOwnerController,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.positiveNumber(),
                            ]),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: CustomTextField(
                                name: 'firstName',
                                label: 'First Name',
                                controller: viewModel.firstNameController,
                                validator: FormBuilderValidators.required(),
                              )),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: CustomTextField(
                                  name: 'middleName',
                                  label: 'Middle Name ',
                                  controller: viewModel.middleNameController,
                                  validator: FormBuilderValidators.required(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CustomTextField(
                            name: 'lastName',
                            label: 'Last Name ',
                            controller: viewModel.lastNameController,
                            validator: FormBuilderValidators.required(),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: CustomTextField(
                                name: 'SSN',
                                label: 'SSN',
                                textInputType: TextInputType.number,
                                controller: viewModel.snnController,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.numeric(),
                                ]),
                              )),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: CustomDatePicker(
                                  name: 'dob',
                                  label: "Date of birth",
                                  inputType: InputType.date,
                                  onChanged: (date) {
                                    viewModel.dateOfBirth = date;
                                  },
                                  validator: FormBuilderValidators.compose(
                                    [
                                      FormBuilderValidators.required(),
                                      FormBuilderValidators.dateTime()
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            name: 'Email',
                            label: 'Email',
                            controller: viewModel.emailController,
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(),
                                FormBuilderValidators.email(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            name: 'phoneNumber',
                            label: 'Phone Number',
                            textInputType: TextInputType.phone,
                            controller: viewModel.phoneNumberController,
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(),
                                FormBuilderValidators.phoneNumber(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            name: 'phoneNumberEXT',
                            label: 'Phone Numebr EXT',
                            textInputType: TextInputType.phone,
                            controller: viewModel.phoneNumberExtController,
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(),
                                FormBuilderValidators.numeric(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            name: 'faxNumber',
                            label: 'Fax Number',
                            textInputType: TextInputType.number,
                            controller: viewModel.faxNumberController,
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(),
                                FormBuilderValidators.numeric(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            name: 'address',
                            label: 'Address',
                            controller: viewModel.addressController,
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: CustomTextField(
                                name: 'apt',
                                label: 'Apt',
                                controller: viewModel.aptController,
                                validator: FormBuilderValidators.compose(
                                  [
                                    FormBuilderValidators.required(),
                                  ],
                                ),
                              )),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: CustomTextField(
                                    name: 'city',
                                    label: 'City',
                                    controller: viewModel.cityController,
                                    validator: FormBuilderValidators.compose(
                                      [
                                        FormBuilderValidators.required(),
                                        FormBuilderValidators.city()
                                      ],
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: CustomTextField(
                                name: 'state',
                                label: 'State',
                                controller: viewModel.stateController,
                                validator: FormBuilderValidators.compose(
                                  [
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.state(),
                                  ],
                                ),
                              )),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: CustomTextField(
                                  name: 'country',
                                  label: 'Country Code',
                                  controller: viewModel.countryController,
                                  validator: FormBuilderValidators.compose(
                                    [
                                      FormBuilderValidators.required(),
                                      FormBuilderValidators.uppercase(),
                                      FormBuilderValidators.maxLength(2),
                                      FormBuilderValidators.alphabetical(),
                                    ],
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
                                child: CustomTextField(
                                  name: 'postalCode',
                                  label: 'Postal Code',
                                  textInputType: TextInputType.number,
                                  controller: viewModel.postalCodeController,
                                  validator: FormBuilderValidators.compose(
                                    [
                                      FormBuilderValidators.required(),
                                      FormBuilderValidators.zipCode(),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: CustomTextField(
                                  name: 'postalCodeExtension',
                                  label: 'Postal Code Extension',
                                  textInputType: TextInputType.number,
                                  controller:
                                      viewModel.postalCodeExtensionController,
                                  validator: FormBuilderValidators.compose(
                                    [
                                      FormBuilderValidators.required(),
                                      FormBuilderValidators.numeric(),
                                    ],
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
                                  child: CustomTextField(
                                name: 'id',
                                label: 'ID',
                                controller: viewModel.idController,
                                validator: FormBuilderValidators.compose(
                                  [
                                    FormBuilderValidators.required(),
                                  ],
                                ),
                              )),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                  child: CustomDropdownField(
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
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CustomTextField(
                            name: 'issuedState',
                            label: 'Issued State',
                            controller: viewModel.issuedStateController,
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(),
                                FormBuilderValidators.state(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  name: 'issuedCountry',
                                  label: 'Issued Country',
                                  controller: viewModel.issuedCountryController,
                                  validator: FormBuilderValidators.compose(
                                    [
                                      FormBuilderValidators.required(),
                                      FormBuilderValidators.country(),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: CustomTextField(
                                  name: 'issuedCity',
                                  label: 'Isssued City',
                                  controller: viewModel.issuedCityController,
                                  validator: FormBuilderValidators.compose(
                                    [
                                      FormBuilderValidators.required(),
                                      FormBuilderValidators.city(),
                                    ],
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
                                  child: CustomDatePicker(
                                name: 'issueDate',
                                label: "Issue Date",
                                inputType: InputType.date,
                                onChanged: (date) {
                                  viewModel.issueDate = date;
                                },
                                validator: FormBuilderValidators.compose(
                                  [
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.dateTime(),
                                  ],
                                ),
                              )),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                  child: CustomDatePicker(
                                name: 'expiryDate',
                                label: 'Expiry Date ',
                                inputType: InputType.date,
                                onChanged: (date) {
                                  viewModel.expiryDate = date;
                                },
                                validator: FormBuilderValidators.compose(
                                  [
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.dateTime(),
                                  ],
                                ),
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          const Row(
                            children: [
                              Icon(Icons.camera_alt),
                              SizedBox(
                                width: 20,
                              ),
                              Text('Add Picture'),
                            ],
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              child: const Text("Add"),
                              onPressed: () {
                                if (viewModel.formKey.currentState
                                        ?.validate() ??
                                    false) {
                                  viewModel
                                      .addBeneficiaryOwner(
                                    context,
                                    merchantId,
                                    merchantPayFacDbId,
                                  )
                                      .then((value) {
                                    if (value) {
                                      onDone();
                                    }
                                  });

                                  // registerOwner(idController.text.toString(), PayFac.toString(), BeneficiaryOwnerTitle, title, firstNameController.text.toString(), "", lastNameController.text.toString(), phoneNumberController.text.toString(), PhoneNumberExtController.text.toString(), FaxNumberController.text.toString(), emailController.text.toString(), percentageOwnerController.text.toString(), SSNController.text.toString(), day.toString(), month.toString(), year.toString(), addressController.text.toString(), AptController.text.toString(), CityController.text.toString(), StateController.text.toString(), CountryController.text.toString(), postalCodeController.text.toString(), postalCodeExtensionController.text.toString());
                                  // generate_password();
                                  // owner_Id = loggedInUser_Global.userId;
                                  // registerUserWithPhoneNumberGolden(emailController.text.toString(), password.toString(), firstNameController.text.toString(), lastNameController.text.toString(), phoneNumberController.text.toString(), context);
                                  // registerOwnersIssuedIdentity(owner_Id.toString(), PayFac.toString(), selectedBeneficiaryType.toString(), idController.text.toString(), IssuedCityController.text.toString(), IssuedStateController.text.toString(), IssuedCountryController.text.toString(), issue_year.toString(), issue_month.toString(), issue_day.toString(), expiry_year.toString(), expiry_month.toString(), expiry_day.toString());
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }
}
