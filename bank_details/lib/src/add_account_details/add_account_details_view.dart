import 'package:bank_details/src/add_account_details/add_account_details_view_model.dart';
import 'package:bank_details/src/add_account_details/add_bank_details/add_bank_details_view.dart';
import 'package:bank_details/src/add_account_details/add_card_details/add_card_details_view.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_credit_card/flutter_credit_card.dart';

class AddBankAccount extends StatelessWidget {
  const AddBankAccount({
    super.key,
    required this.onDone,
    required this.userId,
    required this.mID,
    // required this.onAddBankDetails,
    // required this.onAddCardDetails,
  });
  final VoidCallback onDone;
  final int userId;
  final int mID;
  // final Function(BankDetails) onAddBankDetails;
  // final Function(CreditCardModel) onAddCardDetails;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddAccountDetailsViewModel(
        userId: userId,
        mID: mID,
      ),
      child: Consumer<AddAccountDetailsViewModel>(
        builder: (context, viewModel, _) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: const CustomAppBar(
                title: "Bank Account",
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "This account is used for receving payments for the sold merchandise or services.",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const TabBar(tabs: [
                      Tab(
                        text: "Bank Details",
                      ),
                      Tab(
                        text: "Push to debit card",
                      ),
                    ]),
                    Expanded(
                      child: TabBarView(
                        children: [
                          AddBankDetailsView(
                            onDone: onDone,
                            onAddBankDetails: viewModel.onAddBankDetails,
                          ),
                          AddCardDetailsView(
                            onDone: onDone,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
