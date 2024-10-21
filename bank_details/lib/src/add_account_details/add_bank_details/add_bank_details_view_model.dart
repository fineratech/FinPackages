import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AddBankDetailsViewModel extends ChangeNotifier {
  AddBankDetailsViewModel() {
    initialize();
  }

  bool _isDefault = false;
  String? _ddaType;
  String? _achType;

  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  bool get isDefault => _isDefault;
  String? get ddaType => _ddaType;
  String? get achType => _achType;

  set isDefault(bool val) {
    _isDefault = val;
    notifyListeners();
  }

  set ddaType(String? val) {
    _ddaType = val;
    notifyListeners();
  }

  set achType(String? val) {
    _achType = val;
    notifyListeners();
  }

  late TextEditingController bankName;
  late TextEditingController account;
  late TextEditingController nameOnAccount;
  late TextEditingController routingNumber;

  void initialize() {
    bankName = TextEditingController();
    account = TextEditingController();
    nameOnAccount = TextEditingController();
    routingNumber = TextEditingController();
  }

  @override
  void dispose() {
    bankName.dispose();
    account.dispose();
    nameOnAccount.dispose();
    routingNumber.dispose();
    super.dispose();
  }
}
