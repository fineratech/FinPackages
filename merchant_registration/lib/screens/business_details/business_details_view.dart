import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:merchant_registration/screens/business_details/business_details_view_model.dart';
import 'package:provider/provider.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class BusinessDetailsView extends StatelessWidget {
  const BusinessDetailsView({
    super.key,
    required this.merchantType,
    required this.onDone,
    required this.isIndividual,
    required this.merchant,
    required this.payFacs,
    required this.userId,
  });
  final MerchantType merchantType;
  final Future<void> Function(Merchant) onDone;
  final bool isIndividual;
  final Merchant merchant;
  final List<PayFacsResult> payFacs;
  final int userId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BusinessDetailsViewModel(
        type: merchantType,
        onDone: () {
          onDone(merchant);
        },
      ),
      builder: (context, _) {
        return Consumer<BusinessDetailsViewModel>(
          builder: (context, viewModel, _) {
            return ModalProgressHUD(
              inAsyncCall: viewModel.isLoading,
              child: Scaffold(
                appBar: AppBar(
                  title: Text('${merchantType.name.toUpperCase()} Details'),
                ),
                body: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: FormBuilder(
                    key: viewModel.formKey,
                    child: Column(
                      children: [
                        if (payFacs.isNotEmpty) ...[
                          CustomDropdownField(
                            name: 'payfacName',
                            hintText: 'Payfac Name',
                            label: 'Payfac Name',
                            onChanged: (value) {
                              viewModel.setSelectedPayFac(
                                value as PayFacsResult,
                              );
                            },
                            items: payFacs
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            name: 'payfacId',
                            hintText: 'Payfac ID',
                            label: 'Payfac ID',
                            controller: viewModel.payFacId,
                            // isReadOnly: true,
                            validator: FormBuilderValidators.required(),
                            enabled: false,
                          ),
                          const SizedBox(height: 10),
                        ] else ...[
                          FutureBuilder(
                            future: viewModel.getPayFacs(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator
                                    .adaptive();
                              } else if (snapshot.hasError) {
                                return const Text("Failed to load payfacs");
                              } else if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData) {
                                return Column(
                                  children: [
                                    CustomDropdownField(
                                      name: 'payfacName',
                                      hintText: 'Payfac Name',
                                      label: 'Payfac Name',
                                      onChanged: (value) {
                                        viewModel.setSelectedPayFac(
                                          value as PayFacsResult,
                                        );
                                      },
                                      items: snapshot.data!
                                          .map(
                                            (e) => DropdownMenuItem(
                                              value: e,
                                              child: Text(e.name),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                    const SizedBox(height: 10),
                                    // CustomTextField(
                                    //   name: 'payfacId',
                                    //   hintText: 'Payfac ID',
                                    //   label: 'Payfac ID',
                                    //   controller: viewModel.payFacId,
                                    //   // isReadOnly: true,
                                    //   validator:
                                    //       FormBuilderValidators.required(),
                                    //   enabled: false,
                                    // ),
                                  ],
                                );
                              } else {
                                return const Text("Failed to load payfacs");
                              }
                            },
                          ),
                        ],
                        CustomTextField(
                          name: 'dbaName',
                          hintText: 'DBA Name',
                          label: 'DBA Name',
                          controller: viewModel.dbaName,
                          onChanged: (value) {
                            if (value != null) {
                              viewModel.billingDescriptor.text =
                                  "${viewModel.selectedPayFac?.name ?? ''}____$value";
                            }
                          },
                          validator: FormBuilderValidators.required(),
                        ),
                        const SizedBox(height: 10),
                        if (isIndividual)
                          CustomTextField(
                            name: 'ssn',
                            hintText: 'SSN',
                            label: 'SSN',
                            controller: viewModel.ssnOrTaxId,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.ssn(),
                            ]),
                          )
                        else
                          CustomTextField(
                            name: 'taxId',
                            hintText: 'Federal Tax ID',
                            label: 'Federal Tax ID',
                            controller: viewModel.ssnOrTaxId,
                            validator: FormBuilderValidators.required(),
                          ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                name: 'merchantCategory',
                                hintText: 'Merchant Category',
                                label: 'Merchant Category',
                                controller:
                                    viewModel.merchantCategoryController,
                                isReadOnly: true,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomTextField(
                                name: 'mcc',
                                hintText: 'MCC',
                                label: 'MCC',
                                controller: viewModel.mcc,
                                validator: FormBuilderValidators.required(),
                                // isReadOnly: true,
                                enabled: false,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          name: 'merchantType',
                          hintText: "Merchant Type",
                          label: "Merchant Type",
                          controller: viewModel.merchantTypeController,
                          isReadOnly: true,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          name: 'billingDisc',
                          hintText: 'Billing Disc',
                          label: 'Billing Disc',
                          controller: viewModel.billingDescriptor,
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          name: 'contactPerson',
                          hintText: 'Contact Person',
                          label: 'Contact Person',
                          controller: viewModel.contactPerson,
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          name: 'serviceEmail',
                          hintText: 'Customer Service Email',
                          label: 'Customer Service Email',
                          controller: viewModel.serviceEmail,
                          textInputType: TextInputType.emailAddress,
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(),
                              FormBuilderValidators.email(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          name: 'servicePhone',
                          hintText: 'Customer Service Phone',
                          label: 'Customer Service Phone',
                          controller: viewModel.servicePhone,
                          textInputType: TextInputType.phone,
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(),
                              FormBuilderValidators.phoneNumber(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            onPressed: viewModel.isLoading
                                ? () {}
                                : () async {
                                    if (viewModel.formKey.currentState
                                            ?.saveAndValidate() ??
                                        false) {
                                      viewModel.isLoading = true;
                                      var newMerchant = merchant.copyWith(
                                        payFacName:
                                            viewModel.selectedPayFac?.name,
                                        payFacId: viewModel.selectedPayFac?.id,
                                        payFacTendencyId: viewModel
                                                .selectedPayFac
                                                ?.payFacTenancyId ??
                                            "-1",
                                        dbaName: viewModel.dbaName.text,
                                        ssn: viewModel.ssnOrTaxId.text,
                                        federalTaxId: viewModel.ssnOrTaxId.text,
                                        merchantCategory:
                                            viewModel.type.category,
                                        mcc: viewModel.mcc.text,
                                        type: merchantType,
                                        billingDisc:
                                            viewModel.billingDescriptor.text,
                                        contactPerson:
                                            viewModel.contactPerson.text,
                                        customerServiceEmail:
                                            viewModel.serviceEmail.text,
                                        customerServicePhone:
                                            viewModel.servicePhone.text,
                                      );

                                      viewModel.registerMerchant(
                                        merchant: newMerchant,
                                        userId: userId,
                                        context: context,
                                      );
                                    }
                                  },
                            child: viewModel.isLoading
                                ? const CircularProgressIndicator.adaptive()
                                : const Text('Add'),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
