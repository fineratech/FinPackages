import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:entity_registration/src/Screens/therapist/license_info/license_info_view_model.dart';
import 'package:entity_registration/src/constants/app_colors.dart';
import 'package:entity_registration/src/widgets/image_with_title.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class LicenseInfoView extends StatelessWidget {
  const LicenseInfoView(
      {super.key, required this.onJumpToPage, required this.savelawer});
  final void Function(int) onJumpToPage;
  final Future<void> Function(TherapistModel) savelawer;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LicenseInfoViewModel(),
      child: Consumer<LicenseInfoViewModel>(
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
                  CustomTextField(
                    name: "licenseType",
                    label: "License Type",
                    hintText: "License Type",
                    controller: viewModel.licenseTypeController,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    name: "issuingAuthority",
                    label: "Issuing Authority",
                    hintText: "Issuing Authority",
                    controller: viewModel.issuingAuthorityController,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    name: "firstName",
                    label: "First Name",
                    hintText: "First Name",
                    controller: viewModel.firstNameController,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    name: "lastName",
                    label: "Last Name",
                    hintText: "Last Name",
                    controller: viewModel.lastNameController,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
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
                    selectedItemStyle: const TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    onCityChanged: (value) {
                      viewModel.city = value;
                    },
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    name: "licenseNumber",
                    label: "License Number",
                    hintText: "License Number",
                    controller: viewModel.licenseNumberController,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),
                  const SizedBox(height: 10),
                  CustomDatePicker(
                    name: 'licenseIssueDate',
                    label: 'License Issue Date',
                    inputType: InputType.date,
                    firstDate: DateTime(1900),
                    initialDate: DateTime.now().subtract(
                      const Duration(days: 2),
                    ),
                    lastDate: DateTime.now(),
                    onChanged: (value) {
                      viewModel.licenseIssueDate = value;
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.dateTime()
                    ]),
                  ),
                  const SizedBox(height: 10),
                  CustomDatePicker(
                    name: 'licenseExpiryDate',
                    label: 'License Expiry Date',
                    inputType: InputType.date,
                    firstDate: DateTime.now().add(
                      const Duration(days: 1),
                    ),
                    initialDate: DateTime.now().add(
                      const Duration(days: 1),
                    ),
                    onChanged: (value) {
                      viewModel.licenseExpiryDate = value;
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.dateTime()
                    ]),
                  ),
                  const SizedBox(height: 10),
                  const Text("Add Images"),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ImageWithTitle(
                          svgPath: "assets/images/upload.svg",
                          title: "Front Image",
                          onTap: viewModel.pickFrontImage,
                          isSelected: viewModel.licenseFrontImage != null,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ImageWithTitle(
                          svgPath: "assets/images/upload.svg",
                          title: "Back Image",
                          onTap: viewModel.pickBackImage,
                          isSelected: viewModel.licenseBackImage != null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      child: const Text("Next"),
                      onPressed: () {
                        if (viewModel.formKey.currentState?.validate() ??
                            false) {
                          TherapistModel lawer = TherapistModel(
                            licenseIssuingAuthority:
                                viewModel.issuingAuthorityController.text,
                            licenseFirstName:
                                viewModel.firstNameController.text,
                            licenseLastName: viewModel.lastNameController.text,
                            licenseIssuingCountry: viewModel.country ?? "",
                            licenseIssuingState: viewModel.state ?? "",
                            licenseNumber:
                                viewModel.licenseNumberController.text,
                            licenseIssueDate: viewModel.licenseIssueDate!,
                            licenseExpiryDate: viewModel.licenseExpiryDate!,
                            licenseFrontImage: viewModel.licenseFrontImage,
                            licenseBackImage: viewModel.licenseBackImage,
                            therapistName: "",
                            therapistQualification: "",
                            gender: Gender.other,
                            dateOfBirth: DateTime.now(),
                            certification: "",
                            contactNumber: "",
                            services: [],
                            idType: IdType.other,
                            idNumber: "",
                            idIssuingCountry: "",
                            idIssuingState: "",
                            idExpiryDate: '',
                            licenseType: viewModel.licenseTypeController.text,
                          );
                          savelawer(lawer);
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
