import 'package:flutter/material.dart';
import 'package:merchant_registration/enums/merchant_type.dart';
import 'package:merchant_registration/screens/business_details/business_details_view_model.dart';
import 'package:merchant_registration/widgets/custom_button.dart';
import 'package:merchant_registration/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class BusinessDetailsView extends StatelessWidget {
  const BusinessDetailsView({
    super.key,
    required this.merchantType,
    required this.onDone,
    required this.isIndividual,
  });
  final MerchantType merchantType;
  final VoidCallback onDone;
  final bool isIndividual;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BusinessDetailsViewModel(),
      builder: (context, _) {
        return Consumer<BusinessDetailsViewModel>(
          builder: (context, viewModel, _) {
            return Scaffold(
              appBar: AppBar(
                title: Text('${merchantType.name.toUpperCase()} Details'),
              ),
              body: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    const CustomTextField(
                      name: 'payfacName',
                      hintText: 'Payfac Name',
                      label: 'Payfac Name',
                    ),
                    const SizedBox(height: 10),
                    const CustomTextField(
                      name: 'payfacId',
                      hintText: 'Payfac ID',
                      label: 'Payfac ID',
                    ),
                    const SizedBox(height: 10),
                    const CustomTextField(
                      name: 'dbaName',
                      hintText: 'DBA Name',
                      label: 'DBA Name',
                    ),
                    const SizedBox(height: 10),
                    if (isIndividual)
                      const CustomTextField(
                        name: 'ssn',
                        hintText: 'SSN',
                        label: 'SSN',
                      )
                    else
                      const CustomTextField(
                        name: 'taxId',
                        hintText: 'Federal Tax ID',
                        label: 'Federal Tax ID',
                      ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            name: 'merchantCategory',
                            hintText: 'Merchant Category',
                            label: 'Merchant Category',
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: CustomTextField(
                            name: 'mcc',
                            hintText: 'MCC',
                            label: 'MCC',
                          ),
                        ),
                      ],
                    ),
                    const CustomTextField(
                      name: 'merchantType',
                      hintText: 'Merchant Type',
                      label: 'Merchant Type',
                    ),
                    const SizedBox(height: 10),
                    const CustomTextField(
                      name: 'billingDisc',
                      hintText: 'Billing Disc',
                      label: 'Billing Disc',
                    ),
                    const SizedBox(height: 10),
                    const CustomTextField(
                      name: 'contactPerson',
                      hintText: 'Contact Person',
                      label: 'Contact Person',
                    ),
                    const SizedBox(height: 10),
                    const CustomTextField(
                      name: 'serviceEmail',
                      hintText: 'Customer Service Email',
                      label: 'Customer Service Email',
                    ),
                    const SizedBox(height: 10),
                    const CustomTextField(
                      name: 'servicePhone',
                      hintText: 'Customer Service Phone',
                      label: 'Customer Service Phone',
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        onPressed: onDone,
                        child: const Text('Add'),
                      ),
                    ),
                    const SizedBox(height: 20),
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
