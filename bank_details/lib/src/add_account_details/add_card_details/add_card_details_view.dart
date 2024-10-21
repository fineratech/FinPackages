import 'package:bank_details/src/add_account_details/add_card_details/add_card_details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:provider/provider.dart';

import '../../../app_colors.dart';

class AddCardDetailsView extends StatelessWidget {
  const AddCardDetailsView({
    super.key,
    required this.onDone,
    // required this.onAddCardDetails,
  });
  final VoidCallback onDone;
  // final Function(CreditCardModel) onAddCardDetails;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddCardDetailsViewModel(),
      child: Consumer<AddCardDetailsViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Builder(
              builder: (BuildContext context) {
                return SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      CreditCardWidget(
                        enableFloatingCard: viewModel.useFloatingAnimation,
                        glassmorphismConfig: viewModel.getGlassmorphismConfig(),
                        cardNumber: viewModel.cardNumber,
                        expiryDate: viewModel.expiryDate,
                        cardHolderName: viewModel.cardHolderName,
                        cvvCode: viewModel.cvvCode,
                        frontCardBorder: viewModel.useGlassMorphism
                            ? null
                            : Border.all(color: Colors.grey),
                        backCardBorder: viewModel.useGlassMorphism
                            ? null
                            : Border.all(color: Colors.grey),
                        showBackView: viewModel.isCvvFocused,
                        obscureCardNumber: true,
                        obscureCardCvv: true,
                        isHolderNameVisible: true,
                        cardBgColor: AppColors.cardBgLightColor,
                        // backgroundImage: viewModel.useBackgroundImage
                        //     ? PngAssets.cardBg
                        //     : null,
                        isSwipeGestureEnabled: true,
                        onCreditCardWidgetChange:
                            (CreditCardBrand creditCardBrand) {},
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              CreditCardForm(
                                formKey: viewModel.formKey,
                                obscureCvv: true,
                                obscureNumber: true,
                                cardNumber: viewModel.cardNumber,
                                cvvCode: viewModel.cvvCode,
                                isHolderNameVisible: true,
                                isCardNumberVisible: true,
                                isExpiryDateVisible: true,
                                cardHolderName: viewModel.cardHolderName,
                                expiryDate: viewModel.expiryDate,
                                inputConfiguration: const InputConfiguration(
                                  cardNumberDecoration: InputDecoration(
                                    labelText: 'Number',
                                    hintText: 'XXXX XXXX XXXX XXXX',
                                  ),
                                  expiryDateDecoration: InputDecoration(
                                    labelText: 'Expired Date',
                                    hintText: 'XX/XX',
                                  ),
                                  cvvCodeDecoration: InputDecoration(
                                    labelText: 'CVV',
                                    hintText: 'XXX',
                                  ),
                                  cardHolderDecoration: InputDecoration(
                                    labelText: 'Card Holder',
                                  ),
                                ),
                                onCreditCardModelChange:
                                    viewModel.onCreditCardModelChange,
                              ),
                              const SizedBox(height: 20),
                              // Container(
                              //   padding: const EdgeInsets.symmetric(horizontal: 20),
                              //   width: double.infinity,
                              //   child: ElevatedButton(
                              //     onPressed: viewModel.onValidate,
                              //     child: const Text('Submit'),
                              //   ),
                              // ),
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
                                          if (viewModel.formKey.currentState
                                                  ?.validate() ??
                                              false) {
                                            CreditCardModel cardModel =
                                                CreditCardModel(
                                              viewModel.cardNumber,
                                              viewModel.expiryDate,
                                              viewModel.cardHolderName,
                                              viewModel.cvvCode,
                                              viewModel.isCvvFocused,
                                            );
                                            // onAddCardDetails(cardModel);
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
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
