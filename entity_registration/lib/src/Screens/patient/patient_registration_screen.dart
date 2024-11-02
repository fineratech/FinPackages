import 'package:entity_registration/src/Screens/patient/patient_registration_view_model.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class PatientRegistrationScreen extends StatelessWidget {
  const PatientRegistrationScreen({super.key, required this.onDone});
  final void Function(dynamic) onDone;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PatientRegistrationViewModel(),
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
                    CustomTextField(
                      name: 'location',
                      hintText: 'Location',
                      label: 'Location',
                      controller: viewModel.locationController,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        onPressed: () {
                          if (viewModel.isFormValid()) {
                            final EntityModal entity = EntityModal(
                              patientName: viewModel.patientNameController.text,
                              gender: viewModel.selectedGender,
                              dateOfBirth: viewModel.dateOfBirth,
                              registrationDate: viewModel.registrationDate,
                              location: viewModel.locationController.text,
                            );
                            onDone(entity);
                          }
                        },
                        child: const Text('Submit'),
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
