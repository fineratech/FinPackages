import 'package:entity_registration/src/Screens/registration_success/registration_success_view.dart';
import 'package:fin_api_functions/fin_api_functions.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:logger/logger.dart';

class RegisterLawerViewModel extends ChangeNotifier {
  RegisterLawerViewModel({
    required this.merchantId,
    required this.userId,
    required this.onError,
    required this.onDone,
    required this.context,
    required this.locationId,
  }) {
    initialize();
  }

  TherapistModel? _lawerModel;
  int currentPage = 0;
  late PageController pageController;
  late ApiFunctionsService _apiFunctionsService;
  final String merchantId;
  final String userId;
  final String locationId;
  final BuildContext context;
  final Function(String message) onError;
  void Function(dynamic) onDone;
  final logger = Logger();

  //Form Keys
  final basicFormKey = GlobalKey<FormBuilderState>();
  final licenseFormKey = GlobalKey<FormBuilderState>();
  final idFormKey = GlobalKey<FormBuilderState>();

  bool _isLoading = false;

  TherapistModel? get lawerModel => _lawerModel;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set lawerModel(TherapistModel? lawer) {
    _lawerModel = lawer;
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
    int professionalId =
        await _apiFunctionsService.registerProfessionalWithDescription(
      userId,
      lawerModel?.description ?? '',
      "Legal",
      "Lawer",
      merchantId,
      lawerModel?.idType.name ?? "",
      lawerModel?.idNumber ?? "",
      lawerModel?.idExpiryDate.toString() ?? "",
      lawerModel?.idIssuingState ?? "",
      lawerModel?.idIssuingCountry ?? "",
      lawerModel?.licenseNumber ?? "",
      lawerModel?.licenseType ?? "",
      lawerModel?.licenseExpiryDate.toString() ?? "",
      lawerModel?.licenseIssuingState ?? "",
      lawerModel?.licenseIssuingCountry ?? "",
      lawerModel?.gender.name ?? "",
      lawerModel?.dateOfBirth.toString() ?? "",
      locationId,
    );
    if (professionalId != -1) {
      for (ServiceModel service in lawerModel?.services ?? []) {
        String serviceType = service.type.isNotEmpty ? service.type : "-1";
        try {
          int serviceID = await _apiFunctionsService.addNewService(
            service.name,
            serviceType,
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
        } catch (e) {
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
              entityType: EntityType.lawyer,
              merchantId: merchantId,
              userID: userId,
              locationId: locationId,
              data: lawerModel,
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

  Future<void> saveLawer(TherapistModel lawer) async {
    logger.i("Current Page: $currentPage");
    if (currentPage == 0) {
      lawerModel = lawer;
      jumpToPage(1);
    } else {
      if (currentPage == 1) {
        lawerModel = lawerModel?.copyWith(
          licenseNumber: lawer.licenseNumber,
          licenseBackImage: lawer.licenseBackImage,
          licenseFrontImage: lawer.licenseFrontImage,
          licenseExpiryDate: lawer.licenseExpiryDate,
          licenseIssueDate: lawer.licenseIssueDate,
          licenseFirstName: lawer.licenseFirstName,
          licenseIssuingAuthority: lawer.licenseIssuingAuthority,
          licenseLastName: lawer.licenseLastName,
          licenseIssuingCountry: lawer.licenseIssuingCountry,
          licenseIssuingState: lawer.licenseIssuingState,
          licenseType: lawer.licenseType,
        );
        jumpToPage(2);
      } else {
        lawerModel = lawerModel?.copyWith(
          idExpiryDate: lawer.idExpiryDate,
          idIssuingCountry: lawer.idIssuingCountry,
          idIssuingState: lawer.idIssuingState,
          idNumber: lawer.idNumber,
          idType: lawer.idType,
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
