class BankDetails {
  final String bankName;
  final String account;
  final String nameOnAccount;
  final String type;
  final String routingNumber;
  final bool isDefault;
  BankDetails({
    required this.bankName,
    required this.account,
    required this.nameOnAccount,
    required this.type,
    required this.routingNumber,
    required this.isDefault,
  });

  BankDetails copyWith({
    String? bankName,
    String? account,
    String? nameOnAccount,
    String? type,
    String? routingNumber,
    bool? isDefault,
  }) {
    return BankDetails(
      bankName: bankName ?? this.bankName,
      account: account ?? this.account,
      nameOnAccount: nameOnAccount ?? this.nameOnAccount,
      type: type ?? this.type,
      routingNumber: routingNumber ?? this.routingNumber,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bankName': bankName,
      'account': account,
      'nameOnAccount': nameOnAccount,
      'type': type,
      'routingNumber': routingNumber,
      'isDefault': isDefault,
    };
  }

  factory BankDetails.fromMap(Map<String, dynamic> map) {
    return BankDetails(
      bankName: map['bankName'] as String,
      account: map['account'] as String,
      nameOnAccount: map['nameOnAccount'] as String,
      type: map['type'] as String,
      routingNumber: map['routingNumber'] as String,
      isDefault: map['isDefault'] as bool,
    );
  }

  @override
  String toString() {
    return 'BankDetails(bankName: $bankName, account: $account, nameOnAccount: $nameOnAccount, type: $type, routingNumber: $routingNumber, isDefault: $isDefault)';
  }

  @override
  bool operator ==(covariant BankDetails other) {
    if (identical(this, other)) return true;

    return other.bankName == bankName &&
        other.account == account &&
        other.nameOnAccount == nameOnAccount &&
        other.type == type &&
        other.routingNumber == routingNumber &&
        other.isDefault == isDefault;
  }

  @override
  int get hashCode {
    return bankName.hashCode ^
        account.hashCode ^
        nameOnAccount.hashCode ^
        type.hashCode ^
        routingNumber.hashCode ^
        isDefault.hashCode;
  }
}
