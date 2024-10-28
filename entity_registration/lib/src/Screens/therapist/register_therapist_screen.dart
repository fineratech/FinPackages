import 'package:csc_picker/csc_picker.dart';
import 'package:entity_registration/src/Screens/therapist/register_therapist_view_model.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../widgets/image_with_title.dart';

class RegisterTherapistScreen extends StatelessWidget {
  const RegisterTherapistScreen({
    super.key,
    required this.onDone,
    required this.onAddTherapist,
  });
  final VoidCallback onDone;
  final Future<void> Function(EntityModal) onAddTherapist;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterTherapistViewModel(),
      builder: (context, _) {
        return Consumer<RegisterTherapistViewModel>(
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
                      name: "therapistName",
                      label: "Therapist Name",
                      hintText: "Therapist Name",
                      controller: viewModel.therapistNameController,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      name: "therapistQualification",
                      label: "Therapist Qualification",
                      hintText: "Therapist Qualification",
                      controller: viewModel.therapistQualificationController,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    const SizedBox(height: 10),
                    CustomDropdownField(
                      name: 'gender',
                      label: 'Gender',
                      hintText: 'Gender',
                      onChanged: (value) {
                        viewModel.selectedGender = value;
                      },
                      items: const [
                        DropdownMenuItem(
                          value: Gender.male,
                          child: Text('Male'),
                        ),
                        DropdownMenuItem(
                          value: Gender.female,
                          child: Text('Female'),
                        ),
                        DropdownMenuItem(
                          value: Gender.other,
                          child: Text('Other'),
                        )
                      ],
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomDatePicker(
                      name: 'dob',
                      label: 'Date of Birth',
                      inputType: InputType.date,
                      firstDate: DateTime(1900),
                      initialDate: DateTime.now().subtract(
                        const Duration(days: 2),
                      ),
                      lastDate: DateTime.now().subtract(
                        const Duration(days: 1),
                      ),
                      onChanged: (value) {
                        viewModel.dateOfBirth = value;
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.dateTime()
                      ]),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      name: "certification",
                      label: "Certification",
                      hintText: "Certification",
                      controller: viewModel.certificationController,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    // const SizedBox(height: 10),
                    // CustomTextField(
                    //   name: "licenseNumber",
                    //   label: "License Number",
                    //   hintText: "License Number",
                    //   controller: viewModel.licenseNumberController,
                    //   validator: FormBuilderValidators.compose([
                    //     FormBuilderValidators.required(),
                    //   ]),
                    // ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      name: "contactNumber",
                      label: "Contact Number",
                      hintText: "Contact Number",
                      controller: viewModel.contactNumberController,
                      textInputType: TextInputType.phone,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.phoneNumber(),
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    const SizedBox(height: 10),
                    const Text("What services do you provide?"),
                    const SizedBox(
                      height: 10,
                    ),
                    Wrap(
                        runSpacing: 10,
                        spacing: 10,
                        children: viewModel.services
                            .map(
                              (service) => ImageWithTitle(
                                pngPath: service.pngPath!,
                                title: service.name,
                                isSelected: viewModel.selectedServices
                                    .contains(service),
                                onTap: () {
                                  viewModel.toggleService(service);
                                },
                              ),
                            )
                            .toList()),
                    const SizedBox(
                      height: 10,
                    ),
                    if (!viewModel.showLicenseFields)
                      _buildAddLicenceButton(
                        context: context,
                        onTap: () {
                          viewModel.showLicenseFields = true;
                        },
                      )
                    else ...[
                      const SizedBox(
                        height: 20,
                      ),
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
                      CSCPicker(
                        layout: Layout.horizontal,
                        showCities: false,
                        flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                        currentCountry: viewModel.country,
                        currentState: viewModel.state,
                        // currentCity: viewModel.city,
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
                    ],
                    const SizedBox(height: 20),
                    CustomButton(
                      child: const Text("Submit"),
                      onPressed: () {
                        if (viewModel.formKey.currentState?.validate() ??
                            false) {
                          // EntityModal entityModal = EntityModal.empty();
                          // onAddTherapist()
                        }
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAddLicenceButton({
    required BuildContext context,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: const Row(
        children: [
          Icon(
            Icons.add_circle,
            color: AppColors.greenColor,
            size: 25,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "Add Therapist License",
            style: TextStyle(
              color: AppColors.greenColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
