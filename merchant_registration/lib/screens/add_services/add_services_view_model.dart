import 'package:fin_api_functions/fin_api_functions.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class AddServicesViewModel extends ChangeNotifier {
  AddServicesViewModel() {
    initialize();
  }
  final logger = Logger();

  late ApiFunctionsService apiFunctionsService;

  void initialize() {
    apiFunctionsService = ApiFunctionsService(
      logger: logger,
    );
  }

  Future<void> getServices() async {
    await apiFunctionsService.getAllAvailableServicesByCategory('Healthcare');
  }
}
