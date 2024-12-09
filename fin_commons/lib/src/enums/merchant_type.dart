import 'package:fin_commons/fin_commons.dart';

enum MerchantType {
  hospital,
  pharmacy,
  grocery,
  restaurant,
  trucking,
  realEstate,

  other;

  String get category {
    switch (this) {
      case MerchantType.hospital:
        return 'Healthcare';
      case MerchantType.pharmacy:
        return 'Healthcare';
      case MerchantType.grocery:
        return 'General_store';
      case MerchantType.restaurant:
        return 'Food_and_beverages';
      case MerchantType.trucking:
        return 'Transportation_and_logistics';
      case MerchantType.realEstate:
        return 'Real_estate';
      case MerchantType.other:
        return 'Other';
    }
  }

  EntityType get entity {
    switch (this) {
      case MerchantType.hospital:
        return EntityType.therapist;
      case MerchantType.pharmacy:
        return EntityType.pharmisist;
      case MerchantType.grocery:
        return EntityType.merchandise;
      case MerchantType.restaurant:
        return EntityType.foodMenu;
      case MerchantType.trucking:
        return EntityType.vehicle;
      case MerchantType.realEstate:
        return EntityType.realEstate;
      case MerchantType.other:
        return EntityType.other;
    }
  }
}
