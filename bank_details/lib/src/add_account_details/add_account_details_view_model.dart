import 'package:fin_api_functions/fin_api_functions.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:logger/logger.dart';

class AddAccountDetailsViewModel extends ChangeNotifier {
  late ApiFunctionsService _apiFunctionsService;
  final logger = Logger();
  final int userId;
  final int mID;
  final String locationId;

  AddAccountDetailsViewModel(
      {required this.userId, required this.mID, required this.locationId}) {
    _apiFunctionsService = ApiFunctionsService(
      logger: logger,
    );
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> onAddBankDetails(BankDetails details) async {
    setIsLoading(true);
    String bankId =
        await _apiFunctionsService.addBankNamesDetailedGolden(details.bankName);
    if (bankId.isNotEmpty && bankId != '-1') {
      await _apiFunctionsService.addBankAccountDetailedGolden(
        bankId,
        details.ddaType,
        details.achType,
        details.account,
        details.routingNumber,
        mID,
        userId,
      );
    }
    setIsLoading(false);
  }

  Future<void> onAddCardDetails(
      CreditCardModel cardDetails, CardType? cardType) async {
    setIsLoading(true);
    DateTime expiryDate = DateTime.parse(cardDetails.expiryDate);
    String expiryYear = expiryDate.year.toString();
    String expiryMonth = expiryDate.month.toString();
    await _apiFunctionsService.addBankCardDetailed(
      userId.toString(),
      cardType?.name ?? 'otherBrand',
      cardDetails.cardNumber,
      expiryMonth,
      expiryYear,
      cardDetails.cvvCode,
      cardDetails.cardHolderName,
      locationId,
    );
    setIsLoading(false);
  }
}
