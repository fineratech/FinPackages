enum Gender {
  male,
  female,
  other;

  static Gender fromString(String gender) {
    switch (gender) {
      case 'male' || 'Male':
        return Gender.male;
      case 'female' || 'Female':
        return Gender.female;
      case 'other' || 'Other':
        return Gender.other;
      default:
        return Gender.other;
    }
  }
}
