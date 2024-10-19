// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:merchant_registration/enums/merchant_type.dart';
import 'package:merchant_registration/merchant_registration.dart';

class BusinessDetailsViewModel extends ChangeNotifier {
  BusinessDetailsViewModel({
    required this.type,
  }) {
    initialize();
  }

  PayFacsResult? _selectedPayFac;
  final MerchantType type;
  final formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  PayFacsResult? get selectedPayFac => _selectedPayFac;
  bool get isBusy => _isLoading;
  String? get merchantCategory => {
        MerchantType.hospital: 'Healthcare',
        MerchantType.other: 'Other',
      }[type];

  set selectedPayFac(PayFacsResult? value) {
    _selectedPayFac = value;
    print("Selected PayFac: $value");
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //TextEditing Controllers
  late TextEditingController dbaName;
  late TextEditingController ssnOrTaxId;
  late TextEditingController billingDescriptor;
  late TextEditingController contactPerson;
  late TextEditingController serviceEmail;
  late TextEditingController servicePhone;

  void initialize() {
    dbaName = TextEditingController();
    ssnOrTaxId = TextEditingController();
    billingDescriptor = TextEditingController();
    contactPerson = TextEditingController();
    serviceEmail = TextEditingController();
    servicePhone = TextEditingController();
  }

  @override
  void dispose() {
    dbaName.dispose();
    ssnOrTaxId.dispose();
    billingDescriptor.dispose();
    contactPerson.dispose();
    serviceEmail.dispose();
    servicePhone.dispose();
    super.dispose();
  }
}
