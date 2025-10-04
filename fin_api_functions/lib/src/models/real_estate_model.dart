/// Real Estate property model
class RealEstateProperty {
  final String id;
  final String address;
  final String category;
  final String type;
  final String rent;
  final String price;
  final String fees;
  final String isLeased;
  final String friendlyName;
  final String starRating;
  final String state;
  final String country;
  final String locationId;
  final String managementCompanyId;
  final String images;

  RealEstateProperty({
    required this.id,
    required this.address,
    required this.category,
    required this.type,
    required this.rent,
    required this.price,
    required this.fees,
    required this.isLeased,
    required this.friendlyName,
    required this.starRating,
    required this.state,
    required this.country,
    required this.locationId,
    required this.managementCompanyId,
    required this.images,
  });

  factory RealEstateProperty.fromJson(Map<String, dynamic> json) {
    return RealEstateProperty(
      id: json['Id']?.toString() ?? '',
      address: json['Address']?.toString() ?? '',
      category: json['Category']?.toString() ?? '',
      type: json['Type']?.toString() ?? '',
      rent: json['Rent']?.toString() ?? '',
      price: json['Price']?.toString() ?? '',
      fees: json['Fees']?.toString() ?? '',
      isLeased: json['IsLeased']?.toString() ?? '',
      friendlyName: json['FriendlyName']?.toString() ?? '',
      starRating: json['StarRating']?.toString() ?? '',
      state: json['State']?.toString() ?? '',
      country: json['Country']?.toString() ?? '',
      locationId: json['LocationId']?.toString() ?? '',
      managementCompanyId: json['ManagementCompanyId']?.toString() ?? '',
      images: json['Images']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Address': address,
      'Category': category,
      'Type': type,
      'Rent': rent,
      'Price': price,
      'Fees': fees,
      'IsLeased': isLeased,
      'FriendlyName': friendlyName,
      'StarRating': starRating,
      'State': state,
      'Country': country,
      'LocationId': locationId,
      'ManagementCompanyId': managementCompanyId,
      'Images': images,
    };
  }
}
