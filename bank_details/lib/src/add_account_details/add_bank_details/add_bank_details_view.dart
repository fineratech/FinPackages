import 'package:bank_details/src/add_account_details/add_bank_details/add_bank_details_view_model.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../../../app_colors.dart';
import '../../widgets/header.dart';

class AddBankDetailsView extends StatelessWidget {
  const AddBankDetailsView({
    super.key,
    required this.onDone,
  });
  final VoidCallback onDone;
  // final Function(BankDetails) onAddBankDetails;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddBankDetailsViewModel(),
      child: Consumer<AddBankDetailsViewModel>(
        builder: (context, viewModel, _) {
          return SingleChildScrollView(
            child: FormBuilder(
              key: viewModel.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Header(),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    name: 'bankName',
                    hintText: "Bank Name",
                    controller: viewModel.bankName,
                    validator: FormBuilderValidators.required(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    name: 'account',
                    hintText: "Account",
                    controller: viewModel.account,
                    validator: FormBuilderValidators.required(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          name: "nameOnAccount",
                          hintText: "Name on Account",
                          controller: viewModel.nameOnAccount,
                          validator: FormBuilderValidators.required(),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: CustomDropdownField(
                          name: "type",
                          hintText: "Type",
                          validator: FormBuilderValidators.required(),
                          onChanged: (value) {
                            viewModel.type = value;
                          },
                          items: [
                            "Checking",
                            "Savings",
                          ]
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ),
                              )
                              .toList(),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    name: "routingNumber",
                    hintText: "Routing Number",
                    controller: viewModel.routingNumber,
                    validator: FormBuilderValidators.required(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SwitchListTile(
                    value: viewModel.isDefault,
                    onChanged: (val) {
                      viewModel.isDefault = val;
                    },
                    title: const Text("Set as default"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: onDone,
                            child: const Text(
                              "Skip",
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (viewModel.formKey.currentState?.validate() ??
                                  false) {
                                BankDetails bankDetails = BankDetails(
                                  bankName: viewModel.bankName.text,
                                  account: viewModel.account.text,
                                  nameOnAccount: viewModel.nameOnAccount.text,
                                  type: viewModel.type ?? "Checking",
                                  routingNumber: viewModel.routingNumber.text,
                                  isDefault: viewModel.isDefault,
                                );
                                onAddBankDetails(bankDetails);
                              }
                            },
                            child: const Text(
                              "Next",
                            ),
                          ),
                        )
                      ],
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
