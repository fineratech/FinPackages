import 'package:entity_registration/src/Screens/registration_success/registration_success_view.dart';
import 'package:fin_api_functions/fin_api_functions.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:logger/logger.dart';

class RegisterTherapistViewModel extends ChangeNotifier {
  RegisterTherapistViewModel({
    required this.merchantId,
    required this.userId,
    required this.onError,
    required this.onDone,
    required this.context,
  }) {
    initialize();
  }

  TherapistModel? _therapistModel;
  int currentPage = 0;
  late PageController pageController;
  late ApiFunctionsService _apiFunctionsService;
  final String merchantId;
  final String userId;
  final BuildContext context;
  final Function(String message) onError;
  void Function(dynamic) onDone;
  final logger = Logger();

  //Form Keys
  final basicFormKey = GlobalKey<FormBuilderState>();
  final licenseFormKey = GlobalKey<FormBuilderState>();
  final idFormKey = GlobalKey<FormBuilderState>();

  bool _isLoading = false;

  TherapistModel? get therapistModel => _therapistModel;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set therapistModel(TherapistModel? therapist) {
    therapistModel = therapist;
    notifyListeners();
  }

  void initialize() {
    pageController = PageController(initialPage: currentPage);
    _apiFunctionsService = ApiFunctionsService(
      logger: logger,
    );
  }

  Future<void> registerProfessional() async {
    isLoading = true;
    int professionalId = await _apiFunctionsService.registerProfessional(
      userId,
      "Healthcare",
      "Therapist",
      merchantId,
      therapistModel?.idType.name ?? "",
      therapistModel?.idNumber ?? "",
      therapistModel?.idExpiryDate.toString() ?? "",
      therapistModel?.idIssuingState ?? "",
      therapistModel?.idIssuingCountry ?? "",
      therapistModel?.licenseNumber ?? "",
      therapistModel?.licenseType ?? "",
      therapistModel?.licenseExpiryDate.toString() ?? "",
      therapistModel?.licenseIssuingState ?? "",
      therapistModel?.licenseIssuingCountry ?? "",
      therapistModel?.gender.name ?? "",
      therapistModel?.dateOfBirth.toString() ?? "",
    );
    if (professionalId != -1) {
      for (ServiceModel service in therapistModel?.services ?? []) {
        int serviceID = await _apiFunctionsService.addNewService(
          service.name,
          service.type,
          "-1",
          "-1",
          "-1",
          "-1",
          service.cost,
          "-1",
          professionalId.toString(),
          "-1",
        );
        if (serviceID == -1) {
          onError("Failed to register professional");
          isLoading = false;
          return;
        }
      }
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => RegistrationSuccessView(
              onDone: onDone,
              entityType: EntityType.therapist,
              merchantId: merchantId,
              userID: userId,
              data: therapistModel,
            ),
          ),
        );
      }
    } else {
      isLoading = false;
      onError("Failed to register professional");
    }
    isLoading = false;
  }

  Future<void> saveTherapist(TherapistModel therapist) async {
    if (currentPage == 0) {
      therapistModel = therapist;
    } else {
      if (currentPage == 1) {
        therapistModel = therapistModel?.copyWith(
          licenseNumber: therapist.licenseNumber,
          licenseBackImage: therapist.licenseBackImage,
          licenseFrontImage: therapist.licenseFrontImage,
          licenseExpiryDate: therapist.licenseExpiryDate,
          licenseIssueDate: therapist.licenseIssueDate,
          licenseFirstName: therapist.licenseFirstName,
          licenseIssuingAuthority: therapist.licenseIssuingAuthority,
          licenseLastName: therapist.licenseLastName,
          licenseIssuingCountry: therapist.licenseIssuingCountry,
          licenseIssuingState: therapist.licenseIssuingState,
          licenseType: therapist.licenseType,
        );
      } else {
        therapistModel = therapistModel?.copyWith(
          idExpiryDate: therapist.idExpiryDate,
          idIssuingCountry: therapist.idIssuingCountry,
          idIssuingState: therapist.idIssuingState,
          idNumber: therapist.idNumber,
          idType: therapist.idType,
        );
        registerProfessional();
      }
    }
  }

  void jumpToPage(int page) {
    pageController.jumpToPage(page);
    currentPage = page;
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
