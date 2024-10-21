// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:logger/logger.dart';

class BusinessDetailsViewModel extends ChangeNotifier {
  BusinessDetailsViewModel({
    required this.type,
  }) {
    initialize();
  }

  final Logger logger = Logger();

  PayFacsResult? _selectedPayFac;
  final MerchantType type;
  final formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  PayFacsResult? get selectedPayFac => _selectedPayFac;
  bool get isLoading => _isLoading;
  String? get merchantCategory => {
        MerchantType.hospital: 'Healthcare',
        MerchantType.other: 'Other',
      }[type];

  // set selectedPayFac(PayFacsResult? value) {
  //   _selectedPayFac = value;
  //   payFacId.text = value?.id.toString() ?? '-1';
  //   mcc.text = value?.mcc ?? '-1';
  //   print("Selected PayFac: ${value.toString()}");
  //   notifyListeners();
  // }

  void setSelectedPayFac(PayFacsResult value) {
    _selectedPayFac = value;
    payFacId.text = value.id.toString();
    mcc.text = value.mcc;
    logger.d("Selected PayFac: ${value.toString()}");
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
  late TextEditingController payFacId;
  late TextEditingController merchantCategoryController;
  late TextEditingController mcc;
  late TextEditingController merchantTypeController;

  void initialize() {
    dbaName = TextEditingController();
    ssnOrTaxId = TextEditingController();
    billingDescriptor = TextEditingController();
    contactPerson = TextEditingController();
    serviceEmail = TextEditingController();
    servicePhone = TextEditingController();
    payFacId = TextEditingController();
    merchantCategoryController = TextEditingController(text: merchantCategory);
    mcc = TextEditingController();
    merchantTypeController = TextEditingController(text: type.name);
  }

  @override
  void dispose() {
    dbaName.dispose();
    ssnOrTaxId.dispose();
    billingDescriptor.dispose();
    contactPerson.dispose();
    serviceEmail.dispose();
    servicePhone.dispose();
    payFacId.dispose();
    merchantCategoryController.dispose();
    mcc.dispose();
    merchantTypeController.dispose();
    super.dispose();
  }
}
