enum EntityType {
  patient,
  therapist,
  vehicle,
  realEstate,
  pharmisist,
  merchandise,
  foodMenu,
  driver,
  truck,
  lawyer,
  client,
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
      case EntityType.driver:
        return 'Register Driver';
      case EntityType.truck:
        return 'Register Truck';
      case EntityType.lawyer:
        return 'Register Lawer';
      case EntityType.client:
        return 'Register Client';
      case EntityType.other:
        return 'Register Entity';
    }
  }
}
