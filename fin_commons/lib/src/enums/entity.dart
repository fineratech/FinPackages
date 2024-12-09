enum EntityType {
  patient,
  therapist,
  vehicle,
  realEstate,
  pharmisist,
  merchandise,
  foodMenu,
  other;

  String getPageTitle() {
    switch (this) {
      case EntityType.patient:
        return 'Register Patient';
      case EntityType.therapist:
        return 'Register Therapist';
      case EntityType.vehicle:
        return 'Register Vehicle';
      case EntityType.realEstate:
        return 'Register Real Estate';
      case EntityType.pharmisist:
        return 'Register Pharmisist';
      case EntityType.merchandise:
        return 'Register Merchandise';
      case EntityType.foodMenu:
        return 'Register Food Menu';
      case EntityType.other:
        return 'Register Entity';
    }
  }
}
