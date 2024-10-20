import 'package:entity_registration/src/Screens/entity_registration_view_model.dart';
import 'package:entity_registration/src/Screens/patient/patient_registration_screen.dart';
import 'package:entity_registration/src/Screens/therapist/register_therapist_screen.dart';
import 'package:entity_registration/src/constants/app_colors.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntityRegistrationScreen extends StatelessWidget {
  const EntityRegistrationScreen({
    super.key,
    required this.entityType,
    required this.onDone,
  });
  final EntityType entityType;
  final void Function(EntityModal) onDone;

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
        );
      case EntityType.therapist:
        return RegisterTherapistScreen(
          onDone: onDone,
        );
      case EntityType.other:
        return Container();
    }
  }
}
