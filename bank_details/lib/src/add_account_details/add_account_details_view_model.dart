import 'package:fin_api_functions/fin_api_functions.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AddAccountDetailsViewModel extends ChangeNotifier {
  late ApiFunctionsService _apiFunctionsService;
  final logger = Logger();
  final int userId;
  final int mID;

  AddAccountDetailsViewModel({required this.userId, required this.mID}) {
    _apiFunctionsService = ApiFunctionsService(
      logger: logger,
    );
  }

  Future<void> onAddBankDetails(BankDetails details) async {
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
  }
}
