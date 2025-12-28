import 'package:fin_commons/fin_commons.dart';

enum MerchantType {
  hospital,
  pharmacy,
  grocery,
  restaurant,
  trucking,
  // ignore: constant_identifier_names
  PropertyManagement,
  lawFirm,

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
      case MerchantType.PropertyManagement:
        return 'SubMerchant';
      case MerchantType.lawFirm:
        return 'Legal_Services';
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
      case MerchantType.PropertyManagement:
        return EntityType.realEstate;
      case MerchantType.lawFirm:
        return EntityType.lawer;
      case MerchantType.other:
        return EntityType.other;
    }
  }
}
