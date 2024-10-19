// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Service {
  final String name;
  final String? svgPath;
  final String? pngPath;
  Service({
    required this.name,
    this.svgPath,
    this.pngPath,
  });

  Service copyWith({
    String? name,
    String? svgPath,
    String? pngPath,
  }) {
    return Service(
      name: name ?? this.name,
      svgPath: svgPath ?? this.svgPath,
      pngPath: pngPath ?? this.pngPath,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'svgPath': svgPath,
    };
  }

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      name: map['name'] as String,
      svgPath: map['svgPath'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Service.fromJson(String source) =>
      Service.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Service(name: $name, svgPath: $svgPath)';

  @override
  bool operator ==(covariant Service other) {
    if (identical(this, other)) return true;

    return other.name == name && other.svgPath == svgPath;
  }

  @override
  int get hashCode => name.hashCode ^ svgPath.hashCode;
}
