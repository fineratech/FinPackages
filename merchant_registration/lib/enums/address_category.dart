enum AddressCategory {
  //headquarter, office
  headquarter,
  office,
  other;

  String getName() {
    switch (this) {
      case headquarter:
        return "Headquarter";
      case office:
        return "Office";
      case other:
        return "Other";
    }
  }
}

enum AddressSubCategory {
  commercial,
  residential,
  aggricultural,
  other;

  String getName() {
    switch (this) {
      case commercial:
        return "Commercial";
      case residential:
        return "Residential";
      case aggricultural:
        return "Aggricultural";
      case other:
        return "Other";
    }
  }
}
