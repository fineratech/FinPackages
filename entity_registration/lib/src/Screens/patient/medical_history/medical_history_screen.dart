import 'package:entity_registration/src/Screens/patient/choice_chip.dart';
import 'package:entity_registration/src/Screens/patient/medical_history/medical_history_view_model.dart';
import 'package:entity_registration/src/constants/app_colors.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MedicalHistoryScreen extends StatelessWidget {
  const MedicalHistoryScreen(
      {super.key, required this.onDone, required this.patientId});
  final void Function(dynamic) onDone;
  final String patientId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MedicalHistoryViewModel(
        patientId,
      ),
      child: Consumer<MedicalHistoryViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Medical History',
                style: TextStyle(
                  color: AppColors.primaryColor,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    onDone(null);
                  },
                  child: const Text('Skip'),
                ),
                const SizedBox(width: 10),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text("Do you have any allergies?"),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    children: viewModel.allAllergies
                        .map(
                          (allergy) => CustomChip(
                            label: allergy,
                            selected:
                                viewModel.selectedAllergies.contains(allergy),
                            onSelected: (value) {
                              viewModel.toggleAllergy(allergy);
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text("Have you ever had any of the following?"),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    children: viewModel.allMedicalConditions
                        .map(
                          (history) => CustomChip(
                            label: history,
                            selected: viewModel.selectedMedicalConditions
                                .contains(history),
                            onSelected: (value) {
                              viewModel.toggleMedicalCondition(history);
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      child: const Text("Submit"),
                      onPressed: () {
                        viewModel.submitForm(
                          context: context,
                          onDone: onDone,
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
