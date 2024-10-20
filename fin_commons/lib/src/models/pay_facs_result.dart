class PayFacsResult {
  final String id;
  final String mcc;
  final String name;
  final String payFacTenancyId;
  PayFacsResult({
    required this.id,
    required this.mcc,
    required this.name,
    required this.payFacTenancyId,
  });

  PayFacsResult copyWith({
    String? id,
    String? mcc,
    String? name,
    String? payFacTenancyId,
  }) {
    return PayFacsResult(
      id: id ?? this.id,
      mcc: mcc ?? this.mcc,
      name: name ?? this.name,
      payFacTenancyId: payFacTenancyId ?? this.payFacTenancyId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ID': id,
      'MCC': mcc,
      'Name': name,
      'PayFacTenancyID': payFacTenancyId,
    };
  }

  factory PayFacsResult.fromMap(Map<String, dynamic> map) {
    return PayFacsResult(
      id: map['ID'] as String,
      mcc: map['MCC'] as String,
      name: map['Name'] as String,
      payFacTenancyId: map['PayFacTenancyID'] as String,
    );
  }

  @override
  String toString() {
    return 'PayFacsResult(id: $id, mcc: $mcc, name: $name, payFacTenancyId: $payFacTenancyId)';
  }

  @override
  bool operator ==(covariant PayFacsResult other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.mcc == mcc &&
        other.name == name &&
        other.payFacTenancyId == payFacTenancyId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        mcc.hashCode ^
        name.hashCode ^
        payFacTenancyId.hashCode;
  }
}
