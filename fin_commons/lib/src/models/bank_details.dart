class BankDetails {
  final String bankName;
  final String account;
  final String nameOnAccount;
  final String ddaType;
  final String achType;
  final String routingNumber;
  final bool isDefault;
  BankDetails({
    required this.bankName,
    required this.account,
    required this.nameOnAccount,
    required this.ddaType,
    required this.achType,
    required this.routingNumber,
    required this.isDefault,
  });

  BankDetails copyWith({
    String? bankName,
    String? account,
    String? nameOnAccount,
    String? ddaType,
    String? routingNumber,
    bool? isDefault,
    String? achType,
  }) {
    return BankDetails(
      bankName: bankName ?? this.bankName,
      account: account ?? this.account,
      nameOnAccount: nameOnAccount ?? this.nameOnAccount,
      ddaType: ddaType ?? this.ddaType,
      achType: achType ?? this.achType,
      routingNumber: routingNumber ?? this.routingNumber,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bankName': bankName,
      'account': account,
      'nameOnAccount': nameOnAccount,
      'ddaType': ddaType,
      'achType': achType,
      'routingNumber': routingNumber,
      'isDefault': isDefault,
    };
  }

  factory BankDetails.fromMap(Map<String, dynamic> map) {
    return BankDetails(
      bankName: map['bankName'] as String,
      account: map['account'] as String,
      nameOnAccount: map['nameOnAccount'] as String,
      ddaType: map['ddaType'] as String,
      achType: map['achType'] as String,
      routingNumber: map['routingNumber'] as String,
      isDefault: map['isDefault'] as bool,
    );
  }

  @override
  String toString() {
    return 'BankDetails(bankName: $bankName, account: $account, nameOnAccount: $nameOnAccount, ddaType: $ddaType, routingNumber: $routingNumber, isDefault: $isDefault, achType: $achType)';
  }

  @override
  bool operator ==(covariant BankDetails other) {
    if (identical(this, other)) return true;

    return other.bankName == bankName &&
        other.account == account &&
        other.nameOnAccount == nameOnAccount &&
        other.ddaType == ddaType &&
        other.achType == achType &&
        other.routingNumber == routingNumber &&
        other.isDefault == isDefault;
  }

  @override
  int get hashCode {
    return bankName.hashCode ^
        account.hashCode ^
        nameOnAccount.hashCode ^
        ddaType.hashCode ^
        achType.hashCode ^
        routingNumber.hashCode ^
        isDefault.hashCode;
  }
}
