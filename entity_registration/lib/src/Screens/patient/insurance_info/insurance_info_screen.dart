import 'package:entity_registration/src/Screens/patient/choice_chip.dart';
import 'package:entity_registration/src/Screens/patient/insurance_info/insurance_info_view_model.dart';
import 'package:entity_registration/src/constants/app_colors.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

class InsuranceInfoScreen extends StatelessWidget {
  const InsuranceInfoScreen({
    super.key,
    required this.onDone,
    required this.patientId,
  });
  final void Function(dynamic) onDone;
  final String patientId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => InsuranceInfoViewModel(
        patientId,
      ),
      child: Consumer<InsuranceInfoViewModel>(builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Insurance Information',
              style: TextStyle(
                color: AppColors.primaryColor,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  onDone(null);
                },
                child: const Text('Skip'),
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  "Do you have insurance?",
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomChip(
                        label: "Yes",
                        selected: viewModel.hasInsurance,
                        onSelected: (value) {
                          viewModel.hasInsurance = true;
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                        child: CustomChip(
                      label: "No",
                      selected: !viewModel.hasInsurance,
                      onSelected: (value) {
                        viewModel.hasInsurance = false;
                      },
                    )),
                  ],
                ),
                const SizedBox(height: 20),
                if (viewModel.hasInsurance) ...[
                  FormBuilder(
                    key: viewModel.formKey,
                    child: Column(
                      children: [
                        const Text(
                          "Primary Card Holder",
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 20,
                          children: viewModel.cardHolderOptions
                              .map((e) => CustomChip(
                                    label: e,
                                    selected: viewModel.primaryCardHolder == e,
                                    onSelected: (value) {
                                      viewModel.primaryCardHolder = e;
                                    },
                                  ))
                              .toList(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          name: 'policyHolderName',
                          label: 'Policy Holder Name',
                          controller: viewModel.policyHolderNameController,
                          validator: FormBuilderValidators.required(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          name: 'insuranceCompany',
                          label: 'Insurance Company',
                          controller: viewModel.insuranceCompanyController,
                          validator: FormBuilderValidators.required(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          name: 'idNumber',
                          label: 'ID Number',
                          controller: viewModel.policyNumberController,
                          validator: FormBuilderValidators.required(),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextField(
                          name: 'groupNumber',
                          label: 'Group Number',
                          controller: viewModel.groupNumberController,
                          validator: FormBuilderValidators.required(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      child: const Text('Submit'),
                      onPressed: () => viewModel.submitForm(
                        context: context,
                        onDone: onDone,
                      ),
                    ),
                  )
                ],
              ],
            ),
          ),
        );
      }),
    );
  }
}
