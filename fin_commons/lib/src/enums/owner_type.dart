enum OwnerType {
  beneficiary("BeneficialOwner"),
  control("ControlOwner"),
  other("Other");

  final String value;

  const OwnerType(this.value);

  static OwnerType fromString(String id) {
    switch (id) {
      case 'beneficiary' ||
            'Beneficiary' ||
            "BENEFICIARY" ||
            "BeneficialOwner" ||
            "beneficialOwner" ||
            "BENEFICIALOWNER" ||
            "beneficialowner":
        return OwnerType.beneficiary;
      case 'control' ||
            'Control' ||
            "CONTROL" ||
            "ControlOwner" ||
            "controlOwner" ||
            "CONTROLOWNER" ||
            "controlowner":
        return OwnerType.control;
      case 'other' || 'Other' || 'OTHER':
        return OwnerType.other;
      default:
        return OwnerType.other;
    }
  }
}
