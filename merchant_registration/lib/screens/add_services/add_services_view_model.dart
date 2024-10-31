import 'package:bank_details/bank_details.dart';
import 'package:entity_registration/entity_registration.dart';
import 'package:fin_api_functions/fin_api_functions.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:logger/logger.dart';

class AddServicesViewModel extends ChangeNotifier {
  AddServicesViewModel({
    required BuildContext context,
    required this.type,
    required this.merchantId,
    required this.userId,
    required this.locationId,
  }) {
    initialize(context);
  }
  final logger = Logger();
  final MerchantType type;
  final int merchantId;
  final int userId;
  final int locationId;

  late ApiFunctionsService apiFunctionsService;
  List<ServiceModel>? allServices;
  List<ServiceModel> addedServices = [];
  ServiceModel? _selectedService;

  bool _isError = false;
  bool _isLoading = false;

  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  late TextEditingController costController;

  bool get isError => _isError;
  bool get isLoading => _isLoading;
  ServiceModel? get selectedService => _selectedService;

  set isError(bool value) {
    _isError = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set selectedService(ServiceModel? value) {
    _selectedService = value;
    notifyListeners();
  }

  void initialize(BuildContext context) {
    apiFunctionsService = ApiFunctionsService(
      logger: logger,
    );
    costController = TextEditingController();
    getServices(context);
  }

  Future<void> getServices(BuildContext context) async {
    isLoading = true;
    allServices = await apiFunctionsService
        .getAllAvailableServicesByCategory('Healthcare');
    if (allServices != null) {
      isError = false;
      notifyListeners();
    } else {
      isError = true;
      if (context.mounted) {
        Utils.showErrorToast(
          context: context,
          message: "Failed to get services",
        );
      }
    }
    isLoading = false;
  }

  void addService(ServiceModel service) {
    addedServices.add(service);
    notifyListeners();
  }

  void deleteService(int index) {
    addedServices.removeAt(index);
    notifyListeners();
  }

  String getTypeInString(MerchantType type) {
    switch (type) {
      case MerchantType.hospital:
        return "Healthcare";
      default:
        return type.name;
    }
  }

  Future<void> addServicesToDB({required BuildContext context}) async {
    isLoading = true;
    for (var service in addedServices) {
      int serviceId = await apiFunctionsService.addNewService(
        service.name,
        getTypeInString(type),
        '-1',
        '-1',
        '-1',
        '-1',
        costController.text,
        '-1',
        merchantId.toString(),
        '-1',
      );

      if (serviceId == -1) {
        if (context.mounted) {
          Utils.showErrorToast(
            context: context,
            message: "Failed to register services",
          );
        }
        isLoading = false;
        return;
      }
    }

    isLoading = false;
    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddBankAccount(
            onDone: () {
              if (type == MerchantType.hospital) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EntityRegistrationScreen(
                      entityType: EntityType.therapist,
                      onDone: () {},
                      ownerId: userId.toString(),
                    ),
                  ),
                );
              }
            },
            userId: userId,
            mID: merchantId,
            locationId: locationId.toString(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    costController.dispose();
    super.dispose();
  }
}
