import 'package:fin_api_functions/src/common/app_config.dart';

class ApiEndPoints {
  static const String serviceReferencePathCustomer =
      "CustomerInfoJsonService/CustomerInfoJsonService.svc";
  static const String serviceReferencePathResource =
      "SharingServiceJson/RSServiceJSON.svc";

////Customer Service APIs
  static const String validateUser =
      "$serviceReferencePathCustomer/ValidateUser";

  static const String deleteAccount =
      "$serviceReferencePathCustomer/DeleteAccount";

  static const String registerUserWithPhoneNumber =
      "$serviceReferencePathCustomer/RegisterUserWithPhoneNumber"; //updated the typo

  static const String otpChallenge =
      "$serviceReferencePathCustomer/OTPChallenge";
  static const String acceptOTPChallenge =
      "$serviceReferencePathCustomer/AcceptOTPChallenge";
  static const String addLocationDetailed =
      "$serviceReferencePathResource/AddLocationDetailed";
  static const String addLocationDetailedWithCategorySubCategory =
      "$serviceReferencePathResource/AddLocationDetailedWithCategorySubCategory";
  static const String registerMerchant =
      "$serviceReferencePathResource/RegisterMerchant";
  static const String getAllPayFacs =
      "$serviceReferencePathResource/GetAllPayFacs";
  static const String addBankNamesDetailed =
      "$serviceReferencePathCustomer/AddBankNamesDetailed";
  static const String addBankAccountDetailed =
      "$serviceReferencePathCustomer/AddBankAccountDetailed";

  static const String addBankCardDetailed =
      "$serviceReferencePathCustomer/AddBankCardDetailed";

  static const String registerOwner =
      "$serviceReferencePathResource/RegisterOwner";
  static const String registerOwnersIssuedIdentity =
      "$serviceReferencePathResource/RegisterOwnersIssuedIdentity";

  static const String registerMerchantInPayFacDb =
      "$serviceReferencePathResource/RegisterMerchantInPayFacDb";

  static const String registerRealEstate =
      "$serviceReferencePathResource/RegisterRealEstate";
  static const String addRate = "$serviceReferencePathResource/AddRate";

  static const String getRegisteredVehicles =
      "$serviceReferencePathResource/GetRegisteredVehicles";

  static const String isResourceFavourite =
      "$serviceReferencePathResource/isResourceFavourite";
  static const String makeFavourite =
      "$serviceReferencePathResource/MakeFavourite";

////Resource Service APIs
  // static const String findResourceEfficient =
  //     "$serviceReferencePathResource/FindResourceEfficient/all/${AppConfig.resourceCategory}";
  static const String getAppRealEstateById =
      "$serviceReferencePathResource/GetAppRealEstateById"; //is resource favourite api call
  static const String getBookings = "$serviceReferencePathResource/GetBookings";
  static const String getIDForNewShoppingCart =
      "$serviceReferencePathResource/GetIDForNewShoppingCart";
  static const String placeOrder = "$serviceReferencePathResource/PlaceOrder";
  static const String addNewLeasedItemToShoppingCartSimple =
      "$serviceReferencePathResource/AddNewLeasedItemToShoppingCartSimple";
  static const String collectionID =
      "$serviceReferencePathResource/GetResourceCollectionByResourceId";
  static const String registerVehicle =
      "$serviceReferencePathResource/RegisterVehicle";
  static const String getNotifications =
      "$serviceReferencePathResource/GetNotifications";
  static const String getUserBankAccounts =
      "$serviceReferencePathResource/GetUserBankAccounts";
  static const String addLease = "$serviceReferencePathResource/AddLease";
  static const String totalOutstandingBalanceOfAResource =
      "$serviceReferencePathResource/TotalOutstandingBalanceOfAResource";
  static const String setResourceProperty =
      "$serviceReferencePathResource/SetResourceProperty";
  static const String getResourcePropertyByName =
      "$serviceReferencePathResource/GetResourcePropertyByName";
  static const String getLeasedResources =
      "$serviceReferencePathResource/GetLeasedResources";
  static const String totalOutstandingBalance =
      "$serviceReferencePathResource/TotalOutstandingBalance";
  static const String markAccountAsPaidUntil =
      "$serviceReferencePathResource/MarkAccountAsPaidUntil";
  static const String extendLease = "$serviceReferencePathResource/ExtendLease";

  static const String getAllRealEstate =
      "$serviceReferencePathResource/GetAllRealEstate";
  static const String registerLeasee =
      "$serviceReferencePathResource/RegisterLeasee";

  static const String getUserById = "$serviceReferencePathCustomer/GetUserById";
  static const String getUserByEmail =
      "$serviceReferencePathCustomer/GetUserByEmail";

  static const String addNewItemToShoppingCartSimplest =
      "$serviceReferencePathResource/AddNewItemToShoppingCartSimplest";

  static const String placeOrderDetailed =
      "$serviceReferencePathResource/PlaceOrderDetailed";

  static const String registerTransaction =
      "$serviceReferencePathResource/RegisterTransaction";

  static const String getOrderNumber =
      "$serviceReferencePathResource/GetOrderNumber";

  static const String getAllSubMerchants =
      "$serviceReferencePathResource/GetAllSubMerchants";
  static const String getAllTypesInACategory =
      "$serviceReferencePathResource/GetAllTypesInACategory";

  static const String instrumentScenario =
      "$serviceReferencePathResource/InstrumentScenario";

  static const String registerProfessional =
      "$serviceReferencePathResource/RegisterProfessional";
  static const String addNewService =
      "$serviceReferencePathResource/AddNewService";

  static const String getServiceByProviderId =
      "$serviceReferencePathResource/GetServiceByProviderId";
  static const String getServiceObjectsByProviderId =
      "$serviceReferencePathResource/GetServiceObjectsByProviderId";

  static const String requestSpecificService =
      "$serviceReferencePathResource/RequestSpecificService";

  static const String getProfessionalsOfACompany =
      "$serviceReferencePathResource/GetProfessionalsOfACompany";

  static const String getIndependentProfessionals =
      "$serviceReferencePathResource/GetIndependentProfessionals";

  static const String getDriversOfACompany =
      "$serviceReferencePathResource/GetDriversOfACompany";

  static const String getIndependentDrivers =
      "$serviceReferencePathResource/GetIndependentDrivers";

  static const String registerUserDetailed =
      "$serviceReferencePathCustomer/RegisterUserDetailed";
  static const String registerDriver =
      "$serviceReferencePathResource/RegisterDriver";
  static const String getVehiclesOfACompany =
      "$serviceReferencePathResource/GetVehiclesOfACompany";
  static const String getTransactionByTransactionRefIDProcessor =
      "$serviceReferencePathResource/GetTransactionByTransactionRefIDProcessor";

  static const String getResourceHistory =
      "$serviceReferencePathResource/GetResourceHistory";

  static const String registerTruck =
      "$serviceReferencePathResource/RegisterTruck";

  static const String getAllAvailableServicesByCategory =
      "$serviceReferencePathResource/GetAllAvailableServicesByCategory";

  static const String registerPatient =
      "$serviceReferencePathResource/RegisterPatient";
  static const String findResourceEfficient =
      "$serviceReferencePathResource/FindResourceEfficient";
  static const String getAppObjectProfessionalById =
      "$serviceReferencePathResource/GetAppObjectProfessionalById";

  static const String updateUserDetailed =
      "$serviceReferencePathCustomer/UpdateUserDetailed";

  static const String updatePassword =
      "$serviceReferencePathCustomer/UpdatePassword";

  static const String forgotPassword =
      "$serviceReferencePathCustomer/ForgotPassword";

  static const String contactUs = "$serviceReferencePathCustomer/ContactUs";

  static const String searchServices =
      "$serviceReferencePathResource/SearchServices";
}
