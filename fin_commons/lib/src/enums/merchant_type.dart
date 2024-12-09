enum MerchantType {
  hospital,
  pharmacy,
  grocery,
  restaurant,
  trucking,

  other;

  String get category {
    switch (this) {
      case MerchantType.hospital:
        return 'Healthcare';
      case MerchantType.pharmacy:
        return 'Healthcare';
      case MerchantType.grocery:
        return 'Grocery';
      case MerchantType.restaurant:
        return 'Food_and_beverages';
      case MerchantType.trucking:
        return 'Transportation_and_logistics';
      case MerchantType.other:
        return 'Other';
    }
  }
}
