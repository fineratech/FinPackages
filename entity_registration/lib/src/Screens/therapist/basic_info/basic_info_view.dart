import 'package:entity_registration/src/Screens/therapist/basic_info/basic_info_view_model.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class BasicInfoView extends StatelessWidget {
  const BasicInfoView({
    super.key,
    required this.onJumpToPage,
    required this.saveTherapist,
    required this.merchantId,
  });

  final void Function(int) onJumpToPage;
  final Future<void> Function(TherapistModel) saveTherapist;
  final String merchantId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BasicInfoViewModel(merchantId: merchantId),
      child: Consumer<BasicInfoViewModel>(
        builder: (context, viewModel, _) {
          return viewModel.isLoading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : viewModel.isError
                  ? Column(
                      children: [
                        const Text("Failed to get services"),
                        CustomButton(
                          child: const Text("Retry"),
                          onPressed: () {
                            viewModel.getServices();
                          },
                        ),
                      ],
                    )
                  : SingleChildScrollView(
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
                              controller:
                                  viewModel.therapistQualificationController,
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
                            ...viewModel.allServices!.map(
                              (service) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: ListTile(
                                  title: Text(service.name),
                                  leading: Checkbox(
                                    value: viewModel.selectedServices
                                        .contains(service),
                                    onChanged: (_) {
                                      viewModel.toggleService(service);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: CustomButton(
                                child: const Text("Next"),
                                onPressed: () {
                                  if (viewModel.formKey.currentState
                                          ?.validate() ??
                                      false) {
                                    TherapistModel therapistModel =
                                        TherapistModel(
                                      therapistName: viewModel
                                          .therapistNameController.text,
                                      therapistQualification: viewModel
                                          .therapistQualificationController
                                          .text,
                                      gender: viewModel.selectedGender!,
                                      dateOfBirth: viewModel.dateOfBirth!,
                                      certification: viewModel
                                          .certificationController.text,
                                      contactNumber: viewModel
                                          .contactNumberController.text,
                                      services: viewModel.selectedServices,
                                      idType: IdType.other,
                                      idNumber: "",
                                      idExpiryDate: "",
                                      idIssuingState: "",
                                      idIssuingCountry: "",
                                      licenseIssuingAuthority: "",
                                      licenseFirstName: "",
                                      licenseLastName: "",
                                      licenseIssuingCountry: "",
                                      licenseIssuingState: "",
                                      licenseNumber: "",
                                      licenseExpiryDate: DateTime.now(),
                                      licenseIssueDate: DateTime.now(),
                                      licenseType: "",
                                    );
                                    saveTherapist(therapistModel);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    );
        },
      ),
    );
  }
}
