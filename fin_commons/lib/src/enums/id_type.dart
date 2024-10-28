enum IdType {
  cnic,
  passport,
  stateId,
  other;

  static IdType fromString(String id) {
    switch (id) {
      case 'cnic' || 'Cnic' || "CNIC":
        return IdType.cnic;
      case 'passport' || 'Passport' || "PASSPORT":
        return IdType.passport;
      case 'stateid' ||
            'stateID' ||
            'stateId' ||
            'StateId' ||
            'StateID' ||
            'Stateid' ||
            'STATEID':
        return IdType.stateId;
      case 'other' || 'Other' || 'OTHER':
        return IdType.other;
      default:
        return IdType.other;
    }
  }
}
