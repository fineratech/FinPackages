import 'package:bank_details/src/add_account_details/add_bank_details/add_bank_details_view_model.dart';
import 'package:bank_details/src/models/bank_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

import '../../../app_colors.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/header.dart';

class AddBankDetailsView extends StatelessWidget {
  const AddBankDetailsView(
      {super.key, required this.onSkip, required this.onAddBankDetails});
  final VoidCallback onSkip;
  final Function(BankDetails) onAddBankDetails;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddBankDetailsViewModel(),
      child: Consumer<AddBankDetailsViewModel>(
        builder: (context, viewModel, _) {
          return FormBuilder(
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
                      child: CustomTextField(
                        name: "type",
                        hintText: "Type",
                        controller: viewModel.type,
                        validator: FormBuilderValidators.required(),
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
                const Spacer(),
                SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onSkip,
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
                                type: viewModel.type.text,
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
          );
        },
      ),
    );
  }
}
