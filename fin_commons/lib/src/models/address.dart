class Address {
  final String addressCategory;
  final String addressSubcategory;
  final String streetline1;
  final String apartmentOrSuite;
  final String city;
  final String state;
  final String zip;
  final String country;
  Address({
    required this.addressCategory,
    required this.addressSubcategory,
    required this.streetline1,
    required this.apartmentOrSuite,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
  });

  Address copyWith({
    String? addressCategory,
    String? addressSubcategory,
    String? streetline1,
    String? apartmentOrSuite,
    String? city,
    String? state,
    String? zip,
    String? country,
  }) {
    return Address(
      addressCategory: addressCategory ?? this.addressCategory,
      addressSubcategory: addressSubcategory ?? this.addressSubcategory,
      streetline1: streetline1 ?? this.streetline1,
      apartmentOrSuite: apartmentOrSuite ?? this.apartmentOrSuite,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
      country: country ?? this.country,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'addressCategory': addressCategory,
      'addressSubcategory': addressSubcategory,
      'streetline1': streetline1,
      'apartmentOrSuite': apartmentOrSuite,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      addressCategory: map['addressCategory'] as String,
      addressSubcategory: map['addressSubcategory'] as String,
      streetline1: map['streetline1'] as String,
      apartmentOrSuite: map['apartmentOrSuite'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      zip: map['zip'] as String,
      country: map['country'] as String,
    );
  }

  factory Address.empty() {
    return Address(
      addressCategory: '',
      addressSubcategory: '',
      streetline1: '',
      apartmentOrSuite: '',
      city: '',
      state: '',
      zip: '',
      country: '',
    );
  }

  @override
  bool operator ==(covariant Address other) {
    if (identical(this, other)) return true;

    return other.addressCategory == addressCategory &&
        other.addressSubcategory == addressSubcategory &&
        other.streetline1 == streetline1 &&
        other.apartmentOrSuite == apartmentOrSuite &&
        other.city == city &&
        other.state == state &&
        other.zip == zip &&
        other.country == country;
  }

  @override
  int get hashCode {
    return addressCategory.hashCode ^
        addressSubcategory.hashCode ^
        streetline1.hashCode ^
        apartmentOrSuite.hashCode ^
        city.hashCode ^
        state.hashCode ^
        zip.hashCode ^
        country.hashCode;
  }
}
