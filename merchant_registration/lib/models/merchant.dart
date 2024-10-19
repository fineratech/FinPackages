import 'dart:io';

import 'package:merchant_registration/enums/merchant_type.dart';
import 'package:merchant_registration/models/address.dart';

class Merchant {
  final MerchantType type;
  final File? image;
  final String? imageUrl;
  final bool isIndividual;
  final String merchantName;
  final Address address;
  final String payFacName;
  final String payFacId;
  final String payFacTendencyId;
  final String dbaName;
  final String ssn;
  final String federalTaxId;
  final String merchantCategory;
  final String mcc;
  final String billingDisc;
  final String contactPerson;
  final String customerServiceEmail;
  final String customerServicePhone;
  Merchant({
    required this.type,
    this.image,
    this.imageUrl,
    required this.isIndividual,
    required this.merchantName,
    required this.address,
    required this.payFacName,
    required this.payFacId,
    required this.dbaName,
    required this.ssn,
    required this.federalTaxId,
    required this.merchantCategory,
    required this.mcc,
    required this.billingDisc,
    required this.contactPerson,
    required this.customerServiceEmail,
    required this.customerServicePhone,
    required this.payFacTendencyId,
  });

  Merchant copyWith({
    MerchantType? type,
    File? image,
    bool? isIndividual,
    String? merchantName,
    Address? address,
    String? payFacName,
    String? payFacId,
    String? dbaName,
    String? ssn,
    String? federalTaxId,
    String? merchantCategory,
    String? mcc,
    String? billingDisc,
    String? contactPerson,
    String? customerServiceEmail,
    String? customerServicePhone,
    String? payFacTendencyId,
  }) {
    return Merchant(
      type: type ?? this.type,
      image: image ?? this.image,
      isIndividual: isIndividual ?? this.isIndividual,
      merchantName: merchantName ?? this.merchantName,
      address: address ?? this.address,
      payFacName: payFacName ?? this.payFacName,
      payFacId: payFacId ?? this.payFacId,
      dbaName: dbaName ?? this.dbaName,
      ssn: ssn ?? this.ssn,
      federalTaxId: federalTaxId ?? this.federalTaxId,
      merchantCategory: merchantCategory ?? this.merchantCategory,
      mcc: mcc ?? this.mcc,
      billingDisc: billingDisc ?? this.billingDisc,
      contactPerson: contactPerson ?? this.contactPerson,
      customerServiceEmail: customerServiceEmail ?? this.customerServiceEmail,
      customerServicePhone: customerServicePhone ?? this.customerServicePhone,
      payFacTendencyId: payFacTendencyId ?? this.payFacTendencyId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type.name,
      'imageUrl': imageUrl,
      'isIndividual': isIndividual,
      'merchantName': merchantName,
      'address': address.toMap(),
      'payFacName': payFacName,
      'payFacId': payFacId,
      'dbaName': dbaName,
      'ssn': ssn,
      'federalTaxId': federalTaxId,
      'merchantCategory': merchantCategory,
      'mcc': mcc,
      'billingDisc': billingDisc,
      'contactPerson': contactPerson,
      'customerServiceEmail': customerServiceEmail,
      'customerServicePhone': customerServicePhone,
      'payFacTendencyId': payFacTendencyId,
    };
  }

  factory Merchant.fromMap(Map<String, dynamic> map) {
    return Merchant(
        type: MerchantType.hospital, //TODO: Change to incoming value
        imageUrl: map['imageUrl'],
        isIndividual: map['isIndividual'] as bool,
        merchantName: map['merchantName'] as String,
        address: Address.fromMap(map['address'] as Map<String, dynamic>),
        payFacName: map['payFacName'] as String,
        payFacId: map['payFacId'] as String,
        dbaName: map['dbaName'] as String,
        ssn: map['ssn'] as String,
        federalTaxId: map['federalTaxId'] as String,
        merchantCategory: map['merchantCategory'] as String,
        mcc: map['mcc'] as String,
        billingDisc: map['billingDisc'] as String,
        contactPerson: map['contactPerson'] as String,
        customerServiceEmail: map['customerServiceEmail'] as String,
        customerServicePhone: map['customerServicePhone'] as String,
        payFacTendencyId: map['payFacTendencyId'] as String);
  }

  factory Merchant.empty() {
    return Merchant(
      type: MerchantType.hospital,
      isIndividual: false,
      merchantName: '',
      address: Address.empty(),
      payFacName: '',
      payFacId: '',
      dbaName: '',
      ssn: '',
      federalTaxId: '',
      merchantCategory: '',
      mcc: '',
      billingDisc: '',
      contactPerson: '',
      customerServiceEmail: '',
      customerServicePhone: '',
      payFacTendencyId: '',
    );
  }

  @override
  bool operator ==(covariant Merchant other) {
    if (identical(this, other)) return true;

    return other.type == type &&
        other.image == image &&
        other.isIndividual == isIndividual &&
        other.merchantName == merchantName &&
        other.address == address &&
        other.payFacName == payFacName &&
        other.payFacId == payFacId &&
        other.dbaName == dbaName &&
        other.ssn == ssn &&
        other.federalTaxId == federalTaxId &&
        other.merchantCategory == merchantCategory &&
        other.mcc == mcc &&
        other.billingDisc == billingDisc &&
        other.contactPerson == contactPerson &&
        other.customerServiceEmail == customerServiceEmail &&
        other.customerServicePhone == customerServicePhone;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        image.hashCode ^
        isIndividual.hashCode ^
        merchantName.hashCode ^
        address.hashCode ^
        payFacName.hashCode ^
        payFacId.hashCode ^
        dbaName.hashCode ^
        ssn.hashCode ^
        federalTaxId.hashCode ^
        merchantCategory.hashCode ^
        mcc.hashCode ^
        billingDisc.hashCode ^
        contactPerson.hashCode ^
        customerServiceEmail.hashCode ^
        customerServicePhone.hashCode;
  }
}
