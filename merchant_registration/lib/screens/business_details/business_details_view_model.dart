// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fin_api_functions/fin_api_functions.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:logger/logger.dart';

import '../add_services/add_services_view.dart';

class BusinessDetailsViewModel extends ChangeNotifier {
  BusinessDetailsViewModel({
    required this.type,
    required this.onDone,
  }) {
    initialize();
  }

  final Logger logger = Logger();
  late ApiFunctionsService apiFunctionsService;

  String locationType = "merchantLocation";

  PayFacsResult? _selectedPayFac;
  final MerchantType type;
  final formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;
  final VoidCallback onDone;

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
    payFacId.text = value.payFacTenancyId.toString();
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
    apiFunctionsService = ApiFunctionsService(
      logger: logger,
    );
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

  Future<void> registerMerchant({
    required Merchant merchant,
    required int userId,
    required BuildContext context,
  }) async {
    isLoading = true;
    // Add Merchant Address
    int? locationId = await apiFunctionsService.addLocationWithCategory(
      merchant.address.addressCategory,
      merchant.address.streetline1,
      merchant.address.apartmentOrSuite,
      merchant.address.city,
      merchant.address.state,
      merchant.address.zip,
      merchant.address.country,
      "-1",
      "-1",
      locationType,
      merchant.address.addressCategory,
      merchant.address.addressSubcategory,
      "",
    );
    if (locationId != null && locationId != -1) {
      // Register Merchant
      int? merchantId = await apiFunctionsService.registerMerchantGolden(
        userId.toString(),
        merchant.merchantCategory,
        merchant.type.name,
        merchant.dbaName,
        merchant.mcc,
        merchant.billingDisc,
        merchant.payFacTendencyId,
        merchant.payFacId,
        merchant.customerServiceEmail,
        merchant.customerServicePhone,
        locationId.toString(),
      );
      if (merchantId != null && merchantId != -1) {
        if (context.mounted) {
          Utils.showSuccessToast(
            context: context,
            message: "Merchant Registered Successfully",
          );
        }

        int payFacMerchId = await apiFunctionsService
            .registerMerchantInPayFacDbGolden(merchantId.toString());
        isLoading = false;

        if (context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddServicesView(
                type: type,
                merchantId: merchantId,
                userId: userId,
                locationId: locationId,
                onDone: onDone,
              ),
            ),
          );
        }
      } else {
        if (context.mounted) {
          Utils.showErrorToast(
            context: context,
            message: "Merchant Registration Failed",
          );
        }
      }
    }

    // Naviagte to next screen

    isLoading = false;
  }

  Future<List<PayFacsResult>> getPayFacs() async {
    return await apiFunctionsService.getPayFacsGolden();
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
