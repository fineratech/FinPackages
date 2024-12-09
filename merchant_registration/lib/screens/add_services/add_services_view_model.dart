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
    required this.onDone,
  }) {
    initialize(context);
  }
  final logger = Logger();
  final VoidCallback onDone;
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
    List<ServiceModel>? services =
        await apiFunctionsService.getAllAvailableServicesByCategory(
            'Healthcare'); //TODO: Need to handle other types

    if (services != null) {
      allServices = services.where((service) {
        return service.providerId == "-1";
      }).toList();
      addedServices = services.where((service) {
        return service.providerId == merchantId.toString();
      }).toList();
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
        service.cost,
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
              //TODO: handle other types
              if (type == MerchantType.hospital) {
                //TODO: Need to navigate to benificiary screen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EntityRegistrationScreen(
                      entityType: EntityType.therapist,
                      onDone: (_) {
                        onDone();
                      },
                      userID: userId.toString(),
                      locationId: locationId.toString(),
                      merchantId: merchantId.toString(),
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
