import 'package:fin_api_functions/fin_api_functions.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AddAccountDetailsViewModel extends ChangeNotifier {
  late ApiFunctionsService _apiFunctionsService;
  final logger = Logger();

  AddAccountDetailsViewModel() {
    _apiFunctionsService = ApiFunctionsService(
      logger: logger,
    );
  }

  Future<void> onAddBankDetails(BankDetails details) async {
    // _apiFunctionsService.addBankAccountDetailedGolden(
    //   bankID,
    //   ddaType,
    //   achType,
    //   accountNumber,
    //   routingNumber,
    //   mID,
    //   id,
    // );
  }
}
