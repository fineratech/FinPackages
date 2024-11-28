enum Gender {
  male,
  female,
  unKnown,
  other;

  static Gender fromString(String gender) {
    switch (gender) {
      case 'male' || 'Male':
        return Gender.male;
      case 'female' || 'Female':
        return Gender.female;
      case 'other' || 'Other':
        return Gender.other;
      case 'unknown' || 'Unknown':
        return Gender.unKnown;
      default:
        return Gender.unKnown;
    }
  }
}
