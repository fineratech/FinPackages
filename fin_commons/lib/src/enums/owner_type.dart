enum OwnerType {
  beneficiary,
  control,
  other;

  static OwnerType fromString(String id) {
    switch (id) {
      case 'beneficiary' || 'Beneficiary' || "BENEFICIARY":
        return OwnerType.beneficiary;
      case 'control' || 'Control' || "CONTROL":
        return OwnerType.control;
      case 'other' || 'Other' || 'OTHER':
        return OwnerType.other;
      default:
        return OwnerType.other;
    }
  }
}
