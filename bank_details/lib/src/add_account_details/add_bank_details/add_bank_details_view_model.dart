import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AddBankDetailsViewModel extends ChangeNotifier {
  AddBankDetailsViewModel() {
    initialize();
  }

  bool _isDefault = false;

  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  bool get isDefault => _isDefault;

  set isDefault(bool val) {
    _isDefault = val;
    notifyListeners();
  }

  late TextEditingController bankName;
  late TextEditingController account;
  late TextEditingController nameOnAccount;
  late TextEditingController type;
  late TextEditingController routingNumber;

  void initialize() {
    bankName = TextEditingController();
    account = TextEditingController();
    nameOnAccount = TextEditingController();
    type = TextEditingController();
    routingNumber = TextEditingController();
  }

  @override
  void dispose() {
    bankName.dispose();
    account.dispose();
    nameOnAccount.dispose();
    type.dispose();
    routingNumber.dispose();
    super.dispose();
  }
}
