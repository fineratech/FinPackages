// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../item_type.dart';

class MapItem with ClusterItem {
  final int id;
  final String name;
  final String locationAddress;
  final String city;
  final double latitude;
  final double longitude;
  final String logo;
  final ItemType type;
  final bool isSelected;
  MapItem({
    required this.id,
    required this.name,
    required this.locationAddress,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.logo,
    required this.type,
    required this.isSelected,
  });

  MapItem copyWith({
    int? id,
    String? name,
    String? locationAddress,
    String? city,
    double? latitude,
    double? longitude,
    String? logo,
    bool? isSelected,
    ItemType? type,
  }) {
    return MapItem(
      id: id ?? this.id,
      name: name ?? this.name,
      locationAddress: locationAddress ?? this.locationAddress,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      logo: logo ?? this.logo,
      isSelected: isSelected ?? this.isSelected,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'locationAddress': locationAddress,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'logo': logo,
      'isSelected': isSelected,
      'type': type.index,
    };
  }

  factory MapItem.fromMap(Map<String, dynamic> map) {
    return MapItem(
      id: map['id'] as int,
      name: map['name'] as String,
      locationAddress: map['locationAddress'] as String,
      city: map['city'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      logo: map['logo'] as String,
      isSelected: map['isSelected'] as bool,
      type: ItemType.values[map['type'] as int],
    );
  }

  String toJson() => json.encode(toMap());

  factory MapItem.fromJson(String source) =>
      MapItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Vehicle(id: $id, name: $name, locationAddress: $locationAddress, city: $city, latitude: $latitude, longitude: $longitude, logo: $logo, isSelected: $isSelected)';
  }

  @override
  bool operator ==(covariant MapItem other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.locationAddress == locationAddress &&
        other.city == city &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.logo == logo &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        locationAddress.hashCode ^
        city.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        logo.hashCode ^
        isSelected.hashCode;
  }

  @override
  LatLng get location => LatLng(
        latitude,
        longitude,
      );
}
