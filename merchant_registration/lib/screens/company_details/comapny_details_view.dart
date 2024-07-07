import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:merchant_registration/app_colors.dart';
import 'package:merchant_registration/enums/merchant_type.dart';
import 'package:merchant_registration/screens/business_details/business_details_view.dart';
import 'package:merchant_registration/screens/company_details/company_details_view_model.dart';
import 'package:merchant_registration/widgets/custom_button.dart';
import 'package:merchant_registration/widgets/custom_text_field.dart';
import 'package:merchant_registration/widgets/upload_image.dart';
import 'package:provider/provider.dart';

class CompanyDetailsView extends StatelessWidget {
  const CompanyDetailsView(
      {super.key, required this.merchantType, required this.onDone});
  final MerchantType merchantType;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => CompanyDetailsViewModel(),
        builder: (context, _) {
          return Consumer<CompanyDetailsViewModel>(
            builder: (context, viewModel, _) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Company Details'),
                ),
                body: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      UploadImage(
                        image: viewModel.image,
                        onTap: viewModel.pickImage,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        name: 'soleOwner',
                        hintText: 'Are you the only owner?',
                        isReadOnly: true,
                        suffix: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCharacterButton(
                              isSelected: viewModel.isIndividual,
                              chr: 'Y',
                              onPressed: () {
                                viewModel.isIndividual = true;
                              },
                            ),
                            const SizedBox(width: 5),
                            _buildCharacterButton(
                              isSelected: !viewModel.isIndividual,
                              chr: 'N',
                              onPressed: () {
                                viewModel.isIndividual = false;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Add Business Address",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const CustomTextField(
                        name: 'merchantName',
                        hintText: 'Merchant Name',
                        label: "Merchant Name",
                      ),
                      const SizedBox(height: 10),
                      const CustomTextField(
                        name: 'Address Category',
                        hintText: 'Address Category',
                        label: "Address Category",
                        suffix: Icon(Icons.keyboard_arrow_down_rounded),
                      ),
                      const SizedBox(height: 10),
                      const CustomTextField(
                        name: 'Address Sub-Category',
                        hintText: 'Address Sub-Category',
                        label: "Address Sub-Category",
                        suffix: Icon(Icons.keyboard_arrow_down_rounded),
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              name: 'Street Line 1',
                              hintText: 'Street Line 1',
                              label: "Street Line 1",
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: CustomTextField(
                              name: 'Apartment or Suite',
                              hintText: 'Apartment or Suite',
                              label: "Apartment or Suite",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      CSCPicker(
                        layout: Layout.horizontal,
                        currentCountry: viewModel.country,
                        currentState: viewModel.state,
                        currentCity: viewModel.city,
                        countryDropdownLabel: viewModel.country ?? 'Country',
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
                      // const CustomTextField(
                      //   name: "Country",
                      //   hintText: "Country",
                      //   label: "Country",
                      //   suffix: Icon(Icons.keyboard_arrow_down_rounded),
                      // ),
                      const SizedBox(height: 10),
                      const CustomTextField(
                        name: 'Zip',
                        hintText: 'Zip',
                        label: "Zip",
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          child: const Text('Next'),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BusinessDetailsView(
                                  merchantType: merchantType,
                                  onDone: onDone,
                                  isIndividual: viewModel.isIndividual,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  Widget _buildCharacterButton(
      {bool isSelected = false, required String chr, Function()? onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : AppColors.lightGreyColor,
        ),
        child: Text(
          chr,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
