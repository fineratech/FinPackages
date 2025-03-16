import 'package:csc_picker_plus/csc_picker_plus.dart';
import 'package:entity_registration/src/Screens/patient/insurance_info/insurance_info_screen.dart';
import 'package:entity_registration/src/Screens/patient/medical_history/medical_history_screen.dart';
import 'package:entity_registration/src/Screens/patient/patient_registration_view_model.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';

class PatientRegistrationScreen extends StatelessWidget {
  const PatientRegistrationScreen({
    super.key,
    required this.onDone,
    required this.merchantId,
    required this.userId,
    required this.type,
    required this.locationId,
  });
  final void Function(dynamic) onDone;
  final String merchantId;
  final String userId;
  final EntityType type;
  final String locationId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PatientRegistrationViewModel(
        merchantId: merchantId,
        userId: userId,
        type: type,
        locationId: locationId,
      ),
      builder: (context, _) {
        return Consumer<PatientRegistrationViewModel>(
          builder: (context, viewModel, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: FormBuilder(
                key: viewModel.formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      name: 'patientName',
                      hintText: 'Patient Name',
                      label: 'Patient Name',
                      controller: viewModel.patientNameController,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    const SizedBox(height: 10),
                    CustomDropdownField(
                      name: 'gender',
                      label: 'Gender',
                      hintText: 'Gender',
                      initialValue: viewModel.selectedGender,
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
                    CustomDatePicker(
                      name: 'registrationDate',
                      label: 'Registration Date',
                      inputType: InputType.date,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      onChanged: (value) {
                        viewModel.registrationDate = value;
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.dateTime()
                      ]),
                    ),
                    const SizedBox(height: 10),
                    // CustomTextField(
                    //   name: 'location',
                    //   hintText: 'Location',
                    //   label: 'Location',
                    //   controller: viewModel.locationController,
                    //   validator: FormBuilderValidators.compose([
                    //     FormBuilderValidators.required(),
                    //   ]),
                    // ),
                    const Center(
                      child: Text(
                        "ID Information",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
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
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        onPressed: viewModel.isLoading
                            ? () {}
                            : () async {
                                if (viewModel.isFormValid()) {
                                  final PatientModel patientModel =
                                      PatientModel(
                                    name: viewModel.patientNameController.text,
                                    ownerId: userId,
                                    companyId: merchantId,
                                    mrn: "-1",
                                    idType: viewModel.idType?.name ?? "",
                                    idNumber: viewModel.idNumberController.text,
                                    idExpiry: viewModel.idExpiryDate.toString(),
                                    idIssuingState: viewModel.state ?? "",
                                    idIssuingCountry: viewModel.country ?? "",
                                    gender:
                                        viewModel.selectedGender?.name ?? "",
                                    dob: viewModel.dateOfBirth.toString(),
                                    locationId: locationId,
                                  );
                                  int? patientId =
                                      await viewModel.registerPatient(
                                    context: context,
                                    patient: patientModel,
                                  );
                                  if (patientId != -1 && patientId != null) {
                                    if (context.mounted) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              InsuranceInfoScreen(
                                            patientId: patientId.toString(),
                                            onDone: (_) {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MedicalHistoryScreen(
                                                    patientId:
                                                        patientId.toString(),
                                                    onDone: (_) {
                                                      onDone(patientModel);
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                        child: viewModel.isLoading
                            ? const CircularProgressIndicator.adaptive()
                            : const Text('Submit'),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
