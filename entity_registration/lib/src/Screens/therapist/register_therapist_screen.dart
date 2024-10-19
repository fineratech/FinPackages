import 'package:csc_picker/csc_picker.dart';
import 'package:entity_registration/src/Screens/therapist/register_therapist_view_model.dart';
import 'package:entity_registration/src/models/entity_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../enums/gender.dart';
import '../../widgets/custom_date_picker.dart';
import '../../widgets/custom_dropdown_field.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/image_with_title.dart';

class RegisterTherapistScreen extends StatelessWidget {
  const RegisterTherapistScreen({super.key, required this.onDone});
  final void Function(EntityModal) onDone;

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
                      label: "Therapist Name",
                      hintText: "Therapist Name",
                      controller: viewModel.therapistNameController,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
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
                      label: "Certification",
                      hintText: "Certification",
                      controller: viewModel.certificationController,
                      validator: FormBuilderValidators.compose([
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
                              (service) => GestureDetector(
                                onTap: () {
                                  viewModel.toggleService(service);
                                },
                                child: ImageWithTitle(
                                  pngPath: service.pngPath!,
                                  title: service.name,
                                  isSelected: viewModel.selectedServices
                                      .contains(service),
                                ),
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
                      const CustomTextField(
                        label: "Issuing Authority",
                        hintText: "Issuing Authority",
                      ),
                      const SizedBox(height: 10),
                      const CustomTextField(
                        label: "First Name",
                        hintText: "First Name",
                      ),
                      const SizedBox(height: 10),
                      const CustomTextField(
                        label: "Last Name",
                        hintText: "Last Name",
                      ),
                      const SizedBox(height: 10),
                      CSCPicker(
                        layout: Layout.horizontal,
                        showCities: false,
                        // currentCountry: viewModel.country,
                        // currentState: viewModel.state,
                        // currentCity: viewModel.city,
                        // countryDropdownLabel: viewModel.country ?? 'Country',
                        defaultCountry: CscCountry.United_States,
                        onCountryChanged: (value) {
                          // viewModel.country = value;
                        },
                        onStateChanged: (value) {
                          // viewModel.state = value;
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
                      const CustomTextField(
                        label: "License Number",
                        hintText: "License Number",
                      ),
                      const SizedBox(height: 10),
                      const CustomTextField(
                        label: "License Issue Date",
                        hintText: "License Issue Date",
                        suffix: Icon(
                          Icons.date_range,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const CustomTextField(
                        label: "License Expiry Date",
                        hintText: "License Expiry Date",
                        suffix: Icon(
                          Icons.date_range,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text("Add Images"),
                      const SizedBox(height: 10),
                      const Row(
                        children: [
                          Expanded(
                            child: ImageWithTitle(
                              svgPath: "assets/images/upload.svg",
                              title: "Front Image",
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ImageWithTitle(
                              svgPath: "assets/images/upload.svg",
                              title: "Back Image",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ]
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
