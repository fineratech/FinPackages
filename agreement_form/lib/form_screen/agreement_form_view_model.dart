import 'package:fin_api_functions/fin_api_functions.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class AgreementFormViewModel extends ChangeNotifier {
  AgreementFormViewModel({required String agreementType}) {
    getAgreementFormData(agreementType);
  }
  final ApiFunctionsService _apiFunctionsService = ApiFunctionsService();

  bool _isLoading = false;
  String? _agreementData;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  String? get agreementData => _agreementData;
  bool get isLoading => _isLoading;

  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set agreementData(String? value) {
    _agreementData = value;
    notifyListeners();
  }

  set error(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  Future<void> getAgreementFormData(String type) async {
    isLoading = true;
    try {
      final response = await _apiFunctionsService.getAgreementTemplate(type);
      agreementData = response;
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }

  void onSubmit({
    required BuildContext context,
    required VoidCallback onDone,
  }) {
    if (validateSignature()) {
      onDone();
    } else {
      Utils.showErrorToast(
        context: context,
        message: "Please sign the agreement",
      );
    }
  }

  void clearSignature() {
    signatureGlobalKey.currentState?.clear();
  }

  bool validateSignature() {
    List<Path> paths = signatureGlobalKey.currentState!.toPathList();
    if (paths.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
