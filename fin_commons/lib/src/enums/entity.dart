enum EntityType {
  patient,
  therapist,
  other;

  String getPageTitle() {
    switch (this) {
      case EntityType.patient:
        return 'Register Patient';
      case EntityType.therapist:
        return 'Register Therapist';
      case EntityType.other:
        return 'Register Entity';
    }
  }
}
