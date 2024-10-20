import 'package:flutter/foundation.dart';

class User {
  final String userId;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? password;
  final String? phoneNumber;
  final String? otp;
  final int? getIDForNewShoppingCartID;
  final int? addNewItemToShoppingCartSimplestID;
  final int? placeOrderDetailedID;
  final String? getOrderNumberID;

  final Map<String, dynamic>? registerTransactionID;
  final String? selectedBookingID;
  final String? cartLocation;
  final int? parkingSpotsID;
  final String? rent;
  User({
    required this.userId,
    this.email,
    this.firstName,
    this.lastName,
    this.password,
    this.phoneNumber,
    this.otp,
    this.getIDForNewShoppingCartID,
    this.addNewItemToShoppingCartSimplestID,
    this.placeOrderDetailedID,
    this.getOrderNumberID,
    this.registerTransactionID,
    this.selectedBookingID,
    this.cartLocation,
    this.parkingSpotsID,
    this.rent,
  });

  User copyWith({
    String? userId,
    String? email,
    String? firstName,
    String? lastName,
    String? password,
    String? phoneNumber,
    String? otp,
    int? getIDForNewShoppingCartID,
    int? addNewItemToShoppingCartSimplestID,
    int? placeOrderDetailedID,
    String? getOrderNumberID,
    Map<String, dynamic>? registerTransactionID,
    String? selectedBookingID,
    String? cartLocation,
    int? parkingSpotsID,
    String? rent,
  }) {
    return User(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otp: otp ?? this.otp,
      getIDForNewShoppingCartID:
          getIDForNewShoppingCartID ?? this.getIDForNewShoppingCartID,
      addNewItemToShoppingCartSimplestID: addNewItemToShoppingCartSimplestID ??
          this.addNewItemToShoppingCartSimplestID,
      placeOrderDetailedID: placeOrderDetailedID ?? this.placeOrderDetailedID,
      getOrderNumberID: getOrderNumberID ?? this.getOrderNumberID,
      registerTransactionID:
          registerTransactionID ?? this.registerTransactionID,
      selectedBookingID: selectedBookingID ?? this.selectedBookingID,
      cartLocation: cartLocation ?? this.cartLocation,
      parkingSpotsID: parkingSpotsID ?? this.parkingSpotsID,
      rent: rent ?? this.rent,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'phoneNumber': phoneNumber,
      'OTPChallengeResult': otp,
      'GetIDForNewShoppingCartID': getIDForNewShoppingCartID,
      'AddNewItemToShoppingCartSimplestID': addNewItemToShoppingCartSimplestID,
      'PlaceOrderDetailedID': placeOrderDetailedID,
      'GetOrderNumber': getOrderNumberID,
      'RegisterTransactionID': registerTransactionID,
      'SelectedBookingID': selectedBookingID,
      'CartLocation': cartLocation,
      'ParkingSpotsID': parkingSpotsID,
      'Rent': rent,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'],
      email: map['email'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      password: map['password'],
      phoneNumber: map['phoneNumber'],
      otp: map['OTPChallengeResult'],
      getIDForNewShoppingCartID: map['GetIDForNewShoppingCartID'],
      addNewItemToShoppingCartSimplestID:
          map['AddNewItemToShoppingCartSimplestID'],
      placeOrderDetailedID: map['PlaceOrderDetailedID'],
      getOrderNumberID: map['GetOrderNumber'],
      registerTransactionID: map['RegisterTransactionID'],
      selectedBookingID: map['SelectedBookingID'],
      cartLocation: map['CartLocation'],
      parkingSpotsID: map['ParkingSpotsID'],
      rent: map['Rent'],
    );
  }

  factory User.fromGetUserByIdMap(Map<String, dynamic> map) {
    // loggedInUser_Global.firstName =
    //     userData['GetUserByIdResult']['FirstName'];
    // loggedInUser_Global.lastName =
    //     userData['GetUserByIdResult']['LastName'];
    // loggedInUser_Global.userId = userData['GetUserByIdResult']['UserId'];
    // loggedInUser_Global.email =
    //     userData['GetUserByIdResult']['EmailAddress'];
    // loggedInUser_Global.phoneNumber =
    //     userData['GetUserByIdResult']['CellPhone'];

    // int userPermission = userData['GetUserByIdResult']['Permission'];
    // if (userPermission == 1 ||
    //     userPermission == 3 ||
    //     userPermission == 4 ||
    //     userPermission == 5) {
    //   // User has admin permissions, show admin options
    // }
    return User(
      userId: map['GetUserByIdResult']['UserId'],
      email: map['GetUserByIdResult']['EmailAddress'],
      firstName: map['GetUserByIdResult']['FirstName'],
      lastName: map['GetUserByIdResult']['LastName'],
      phoneNumber: map['GetUserByIdResult']['CellPhone'],
    );
  }

  @override
  String toString() {
    return 'User(userId: $userId, email: $email, firstName: $firstName, lastName: $lastName, password: $password, phoneNumber: $phoneNumber, otp: $otp, getIDForNewShoppingCartID: $getIDForNewShoppingCartID, addNewItemToShoppingCartSimplestID: $addNewItemToShoppingCartSimplestID, placeOrderDetailedID: $placeOrderDetailedID, getOrderNumberID: $getOrderNumberID, registerTransactionID: $registerTransactionID, selectedBookingID: $selectedBookingID, cartLocation: $cartLocation, parkingSpotsID: $parkingSpotsID, rent: $rent)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.email == email &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.password == password &&
        other.phoneNumber == phoneNumber &&
        other.otp == otp &&
        other.getIDForNewShoppingCartID == getIDForNewShoppingCartID &&
        other.addNewItemToShoppingCartSimplestID ==
            addNewItemToShoppingCartSimplestID &&
        other.placeOrderDetailedID == placeOrderDetailedID &&
        other.getOrderNumberID == getOrderNumberID &&
        mapEquals(other.registerTransactionID, registerTransactionID) &&
        other.selectedBookingID == selectedBookingID &&
        other.cartLocation == cartLocation &&
        other.parkingSpotsID == parkingSpotsID &&
        other.rent == rent;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        email.hashCode ^
        firstName.hashCode ^
        lastName.hashCode ^
        password.hashCode ^
        phoneNumber.hashCode ^
        otp.hashCode ^
        getIDForNewShoppingCartID.hashCode ^
        addNewItemToShoppingCartSimplestID.hashCode ^
        placeOrderDetailedID.hashCode ^
        getOrderNumberID.hashCode ^
        registerTransactionID.hashCode ^
        selectedBookingID.hashCode ^
        cartLocation.hashCode ^
        parkingSpotsID.hashCode ^
        rent.hashCode;
  }
}
