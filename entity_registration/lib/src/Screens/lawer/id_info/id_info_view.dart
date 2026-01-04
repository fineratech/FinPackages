import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:entity_registration/src/Screens/lawer/id_info/id_info_view_model.dart';
import 'package:entity_registration/src/constants/app_colors.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class IdInfoView extends StatelessWidget {
  const IdInfoView({
    super.key,
    required this.onJumpToPage,
    required this.saveLawer,
  });
  final void Function(int) onJumpToPage;
  final Future<void> Function(TherapistModel) saveLawer;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => IdInfoViewModel(),
      child: Consumer<IdInfoViewModel>(
        builder: (context, viewModel, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FormBuilder(
              key: viewModel.formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  // CustomTextField(
                  //   name: "issuingAuthority",
                  //   label: "Issuing Authority",
                  //   hintText: "Issuing Authority",
                  //   controller: viewModel.issuingAuthorityController,
                  //   validator: FormBuilderValidators.compose([
                  //     FormBuilderValidators.required(),
                  //   ]),
                  // ),
                  // const SizedBox(height: 10),
                  // CustomTextField(
                  //   name: "firstName",
                  //   label: "First Name",
                  //   hintText: "First Name",
                  //   controller: viewModel.firstNameController,
                  //   validator: FormBuilderValidators.compose([
                  //     FormBuilderValidators.required(),
                  //   ]),
                  // ),
                  // const SizedBox(height: 10),
                  // CustomTextField(
                  //   name: "lastName",
                  //   label: "Last Name",
                  //   hintText: "Last Name",
                  //   controller: viewModel.lastNameController,
                  //   validator: FormBuilderValidators.compose([
                  //     FormBuilderValidators.required(),
                  //   ]),
                  // ),
                  // const SizedBox(height: 10),
                  CustomDropdownField(
                    name: 'idType',
                    hintText: 'ID Type',
                    label: 'ID Type',
                    initialValue: viewModel.idType,
                    items: IdType.values
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      viewModel.idType = value;
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    name: "idNumber",
                    label: "ID Number",
                    hintText: "ID Number",
                    controller: viewModel.idNumberController,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(height: 10),
                  CustomDatePicker(
                    name: 'idIssueDate',
                    label: 'ID Issue Date',
                    inputType: InputType.date,
                    firstDate: DateTime(1900),
                    initialDate: DateTime.now().subtract(
                      const Duration(days: 2),
                    ),
                    lastDate: DateTime.now(),
                    onChanged: (value) {
                      viewModel.idIssueDate = value;
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.dateTime()
                    ]),
                  ),
                  const SizedBox(height: 10),
                  CustomDatePicker(
                    name: 'idExpiryDate',
                    label: 'ID Expiry Date',
                    inputType: InputType.date,
                    firstDate: DateTime.now().add(
                      const Duration(days: 1),
                    ),
                    initialDate: DateTime.now().add(
                      const Duration(days: 1),
                    ),
                    onChanged: (value) {
                      viewModel.idExpiryDate = value;
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.dateTime()
                    ]),
                  ),
                  const SizedBox(height: 10),
                  CSCPickerPlus(
                    layout: Layout.horizontal,
                    showCities: false,
                    flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                    currentCountry: viewModel.country,
                    currentState: viewModel.state,
                    currentCity: viewModel.city,
                    countryDropdownLabel: viewModel.country ?? "Country",
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
                  const SizedBox(height: 10),

                  // const Text("Add Images"),
                  // const SizedBox(height: 10),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: ImageWithTitle(
                  //         svgPath: "assets/images/upload.svg",
                  //         title: "Front Image",
                  //         onTap: viewModel.pickFrontImage,
                  //         isSelected: viewModel.idFrontImage != null,
                  //       ),
                  //     ),
                  //     const SizedBox(width: 10),
                  //     Expanded(
                  //       child: ImageWithTitle(
                  //         svgPath: "assets/images/upload.svg",
                  //         title: "Back Image",
                  //         onTap: viewModel.pickBackImage,
                  //         isSelected: viewModel.idBackImage != null,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      child: const Text("Submit"),
                      onPressed: () {
                        if (viewModel.formKey.currentState?.validate() ??
                            false) {
                          TherapistModel lawer = TherapistModel(
                            idIssuingCountry: viewModel.country ?? "",
                            idIssuingState: viewModel.state ?? "",
                            idNumber: viewModel.idNumberController.text,
                            idExpiryDate: viewModel.idExpiryDate.toString(),
                            therapistName: "",
                            therapistQualification: "",
                            gender: Gender.other,
                            dateOfBirth: DateTime.now(),
                            certification: "",
                            contactNumber: "",
                            services: [],
                            idType: viewModel.idType ?? IdType.other,
                            licenseExpiryDate: DateTime.now(),
                            licenseFrontImage: null,
                            licenseBackImage: null,
                            licenseFirstName: "",
                            licenseIssuingAuthority: "",
                            licenseIssuingCountry: "",
                            licenseIssuingState: "",
                            licenseIssueDate: DateTime.now(),
                            licenseLastName: "",
                            licenseNumber: "",
                            licenseType: "",
                          );
                          saveLawer(lawer);
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
