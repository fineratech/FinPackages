enum MerchantType {
  hospital,
  pharmacy,
  grocery,
  restaurant,

  other;

  String get category {
    switch (this) {
      case MerchantType.hospital:
        return 'Healthcare';
      case MerchantType.pharmacy:
        return 'Pharmacy';
      case MerchantType.grocery:
        return 'Grocery';
      case MerchantType.restaurant:
        return 'Restaurant';
      case MerchantType.other:
        return 'Other';
    }
  }
}
