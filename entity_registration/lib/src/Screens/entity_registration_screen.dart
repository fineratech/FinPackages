import 'package:entity_registration/src/Screens/driver/driver_registration_screen.dart';
import 'package:entity_registration/src/Screens/entity_registration_view_model.dart';
import 'package:entity_registration/src/Screens/patient/patient_registration_screen.dart';
import 'package:entity_registration/src/Screens/therapist/register_therapist_screen.dart';
import 'package:entity_registration/src/Screens/truck/truck_registration_screen.dart';
import 'package:entity_registration/src/constants/app_colors.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntityRegistrationScreen extends StatelessWidget {
  const EntityRegistrationScreen({
    super.key,
    required this.entityType,
    required this.onDone,
    required this.userID,
    required this.merchantId,
    required this.locationId,
    this.isSkipable = false,
  });
  final EntityType entityType;
  final void Function(dynamic) onDone;
  final String userID;
  final String merchantId;
  final String locationId;
  final bool isSkipable;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EntityRegistrationViewModel(),
      builder: (context, _) => Consumer<EntityRegistrationViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                entityType.getPageTitle(),
                style: const TextStyle(
                  color: AppColors.primaryColor,
                ),
              ),
              actions: [
                if (isSkipable) ...[
                  TextButton(
                    onPressed: () {
                      onDone(null);
                    },
                    child: const Text('Skip'),
                  ),
                  const SizedBox(width: 10),
                ]
              ],
            ),
            body: getPage(entityType),
          );
        },
      ),
    );
  }

  Widget getPage(EntityType type) {
    switch (type) {
      case EntityType.patient:
        return PatientRegistrationScreen(
          onDone: onDone,
          merchantId: merchantId,
          userId: userID,
          type: type,
          locationId: locationId,
        );
      case EntityType.therapist:
        return RegisterTherapistScreen(
          onDone: onDone,
          merchantId: merchantId,
          userId: userID,
          type: type,
          locationId: locationId,
        );

      case EntityType.truck:
        return RegisterTruck(
          onDone: onDone,
          merchantId: merchantId,
          userId: userID,
          type: type,
          locationId: locationId,
        );
      case EntityType.driver:
        return RegisterDriver(
          onDone: onDone,
          merchantId: merchantId,
          userId: userID,
          type: type,
          locationId: locationId,
        );
      case EntityType.lawer:
        return Container(); //TODO: Add Lawer Registration Screen

      case EntityType.other:
        return Container();
      default:
        return Container();
    }
  }
}
