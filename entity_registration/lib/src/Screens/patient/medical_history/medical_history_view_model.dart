import 'package:fin_api_functions/fin_api_functions.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:flutter/material.dart';

class MedicalHistoryViewModel extends ChangeNotifier {
  MedicalHistoryViewModel(this.patientId);
  final ApiFunctionsService _apiFunctionsService = ApiFunctionsService();

  final String patientId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<String> allAllergies = [
    "No Known Allergies",
    "Adhesive Tape",
    "Anesthesia",
    "Aspirin",
    "Codeine",
    "Dairy Products",
    "Iodine",
    "Latex",
    "Morphine",
    "Penicillin"
  ];
  List<String> allMedicalConditions = [
    "NONE of the problems listed",
    "Chest pain",
    "Hypertension",
    "Osteoporosis",
    "Allergies",
    "Congestive heart failure",
    "Hypogonadism male",
    "Pulmonary embolism",
    "Anemia",
    "Chronic fatigue syndrome",
    "Hypothyroidism",
    "Seizure disorders",
    "Arthritis conditions",
    "Depression",
    "Infection problems",
    "Shortness of breath",
    "Asthma",
    "Diabetes",
    "Insomnia",
    "Sinus conditions",
    "Arterial fibrillation",
    "Bleeding problems",
    "BPH",
    "CAD coronary artery disease",
    "Cancer",
    "Cardiac arrest",
    "Celiac disease",
    "Drug or alcohol abuse",
    "Erectile dysfunction",
    "Fibromyalgia",
    "Gerd",
    "Heart disease",
    "Hyperinsulinemia",
    "Hyperlipidemia",
    "Irritable bowel syndrome",
    "Kidney problems",
    "Menopause",
    "Migraines",
    "Neuropathy",
    "Onychomycosis",
    "Organ injury",
    "Stroke",
    "Syndrome X",
    "Tremors",
    "Wheat allergy"
  ];

  List<String> _selectedAllergies = [];
  List<String> _selectedMedicalConditions = [];
  List<String> get selectedAllergies => _selectedAllergies;
  List<String> get selectedMedicalConditions => _selectedMedicalConditions;

  set selectedAllergies(List<String> allergies) {
    _selectedAllergies = allergies;
    notifyListeners();
  }

  set selectedMedicalConditions(List<String> medicalConditions) {
    _selectedMedicalConditions = medicalConditions;
    notifyListeners();
  }

  void toggleAllergy(String allergy) {
    if (_selectedAllergies.contains(allergy)) {
      _selectedAllergies.remove(allergy);
    } else {
      _selectedAllergies.add(allergy);
    }
    notifyListeners();
  }

  void toggleMedicalCondition(String medicalCondition) {
    if (_selectedMedicalConditions.contains(medicalCondition)) {
      _selectedMedicalConditions.remove(medicalCondition);
    } else {
      _selectedMedicalConditions.add(medicalCondition);
    }
    notifyListeners();
  }

  Future<void> submitForm({
    required BuildContext context,
    required void Function(dynamic) onDone,
  }) async {
    try {
      isLoading = true;
      List<Future> futures = [];
      futures.add(_apiFunctionsService.setResourceProperty(
        "MedicalHistory",
        selectedMedicalConditions.join(","),
        patientId,
      ));
      futures.add(_apiFunctionsService.setResourceProperty(
        "Allergies",
        selectedAllergies.join(","),
        patientId,
      ));
      await Future.wait(futures);
      isLoading = false;
      if (context.mounted) {
        Utils.showSuccessToast(
          context: context,
          message: "Medical History updated successfully",
        );
      }
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
