import 'package:fin_api_functions/fin_api_functions.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class InsuranceInfoViewModel extends ChangeNotifier {
  InsuranceInfoViewModel(
    this.patientId,
  ) {
    initializeControllers();
  }
  final ApiFunctionsService _apiFunctionsService = ApiFunctionsService();

  GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  //TextEditing Controllers
  late TextEditingController policyHolderNameController;
  late TextEditingController insuranceCompanyController;
  late TextEditingController policyNumberController;
  late TextEditingController groupNumberController;

  final String patientId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<String> cardHolderOptions = ["Self", "Spouse", "Parent", "Other"];
  String _primaryCardHolde = '';
  String get primaryCardHolder => _primaryCardHolde;

  set primaryCardHolder(String value) {
    _primaryCardHolde = value;
    notifyListeners();
  }

  bool _hasInsurance = false;
  bool get hasInsurance => _hasInsurance;

  set hasInsurance(bool value) {
    _hasInsurance = value;
    notifyListeners();
  }

  void initializeControllers() {
    policyHolderNameController = TextEditingController();
    insuranceCompanyController = TextEditingController();
    policyNumberController = TextEditingController();
    groupNumberController = TextEditingController();
  }

  Future<void> submitForm({
    required BuildContext context,
    required void Function(dynamic) onDone,
  }) async {
    if (formKey.currentState!.saveAndValidate()) {
      try {
        isLoading = true;
        await _apiFunctionsService.provideInsuranceInfo(
          'Primary',
          patientId,
          'Yes',
          primaryCardHolder,
          policyHolderNameController.text,
          insuranceCompanyController.text,
          policyNumberController.text,
          groupNumberController.text,
        );
        isLoading = false;
        onDone(null);
      } catch (e) {
        isLoading = false;
        if (context.mounted) {
          Utils.showErrorToast(
            context: context,
            message: "Something went wrong",
          );
        }
      }
    }
  }

  @override
  void dispose() {
    policyHolderNameController.dispose();
    insuranceCompanyController.dispose();
    policyNumberController.dispose();
    groupNumberController.dispose();
    super.dispose();
  }
}
