import 'package:fin_api_functions/src/services/api_service.dart';
import 'package:fin_commons/fin_commons.dart';
import 'package:logger/logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../common/api_endpoints.dart';

class ApiFunctionsService {
  ApiFunctionsService({
    this.talker,
    this.accessToken,
    this.logger,
  }) {
    apiService = ApiService(
      logger: logger,
      talker: talker,
      accessToken: accessToken,
    );
  }
  late ApiService apiService;
  final Talker? talker;
  final String? accessToken;
  final Logger? logger;

  // Auth APIs
  Future<RequestResponse> signInGolden(String email, String password) async {
    final String url = '${ApiEndPoints.validateUser}/$email/$password';
    RequestResponse response = await apiService.get(endPoint: url);

    return response;
  }

  Future<bool> acceptOTPChallengeGolden(String phoneOrEmail, String otp) async {
    final url = '${ApiEndPoints.acceptOTPChallenge}/$phoneOrEmail/$otp';
    var apiData = await apiService.get(endPoint: url);
    return apiData.success;
  }

  Future<String?> requestOTPChallengeGolden(
      String phoneOrEmail, bool isEmail) async {
    final url = '${ApiEndPoints.otpChallenge}/$phoneOrEmail/$isEmail';
    var apiData = await apiService.get(endPoint: url);
    if (apiData.success) {
      Map<String, dynamic> otpChallengeResponse = apiData.data;
      String otp = otpChallengeResponse['OTPChallengeResult'];
      // loggedInUser_Global.OTP = otp;

      return otp;
    }
    return null;
  }

  Future<int?> registerUserWithPhoneNumberGolden(
    String contactEmail,
    String strPassword,
    String strFirstName,
    String strLastName,
    String strPhone,
  ) async {
    // loggedInUser_Global.email = contactEmail;

    // loggedInUser_Global.password = strPassword;
    // loggedInUser_Global.firstName = strFirstName;
    // loggedInUser_Global.lastName = strLastName;
    // loggedInUser_Global.phoneNumber = strPhone;

    final url =
        '${ApiEndPoints.registerUserWithPhoneNumber}/$contactEmail/$strPassword/$strFirstName/$strLastName/$strPhone';

    var response = await apiService.get(endPoint: url);

    if (response.success) {
      final dynamic responseData = response.data;
      int userData;
      // Check if the responseData is a string and equals "-2"
      if (responseData is String && responseData == "-2") {
        await requestOTPChallengeGolden(contactEmail, true);
        // Handle the case where the response is "-2" (existing user)
        userData = -2; // Use a special value or handle accordingly
        // snackbarService.showCustomSnackBar(
        //   variant: SnackbarType.error,
        //   message: 'Existing User tried to register.',
        // );
      } else {
        // If it's not "-2", parse it as an integer
        userData = int.tryParse(responseData.toString()) ??
            -1; // Use -1 or handle accordingly

        // loggedInUser_Global.userId = userData;
        // Set the email in shared preferences after a successful registration
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs
        //   ..remove('userId')
        //   ..setInt('userId', loggedInUser_Global.userId = userData);

        // Update storedContactEmail with the new contactEmail
        // loggedInUser_Global.email = contactEmail;
        // prefs.setString('contactEmail', loggedInUser_Global.email);
        // if (userData == -1) {
        //   snackbarService.showCustomSnackBar(
        //     variant: SnackbarType.error,
        //     message: 'User registration failed.',
        //   );
        // } else {
        //   snackbarService.showCustomSnackBar(
        //     variant: SnackbarType.success,
        //     message: 'User registered successfully.',
        //   );
        // }
      }
      return userData;
    }
    return null;
  }

  Future<int?> registerMerchantGolden(
    String userID,
    String
        category, // healthCare, trucking, realEstate, resturants, b2b, professionalServices, travelAndEntertainment, government, education.
    String type, // hospital, clinic, urgentCare, groupOfHospitals, other
    String dbaName,
    String mcc,
    String billingDescriptor,
    String payFacTenancyID,
    String payFacID,
    String customerServiceContactEmail,
    String customerServiceContactPhone,
    String locationID,
  ) async {
    final url =
        '${ApiEndPoints.registerMerchant}/$userID/$category/$type/$dbaName/$mcc/$billingDescriptor/$payFacTenancyID/$payFacID/$customerServiceContactEmail/$customerServiceContactPhone/$locationID';
    var response = await apiService.get(endPoint: url);
    if (response.success) {
      final dynamic responseData = response.data;
      // loggedIn_Merchent.Merchantid = responseData;
      int merchantId = int.tryParse(responseData.toString()) ??
          -1; // Use -1 or handle accordingly
      return merchantId;
    }
    return null;
  }

  Future<int?> addLocationWithCategory<AppObjectsAddress>(
    String friendlyName,
    String address,
    String apt,
    String city,
    String state,
    String zip,
    String country,
    String latitude,
    String longitude,
    String locationType, //merchantLocation
    String locationCategory, //headquarter, office
    String locationSubCategory, //commercial, residential, aggricultural
    String locationPurpose,
  ) async {
    final url =
        '${ApiEndPoints.addLocationDetailedWithCategorySubCategory}/$locationType/$locationCategory/$locationSubCategory/$friendlyName/$address/$apt/$city/$state/$zip/$country/$latitude/$longitude';
    var response = await apiService.get(endPoint: url);
    if (response.success) {
      //final dynamic responseData = response.data;

      // if (locationType == 'MerchantLocation') {
      //   loggedIn_Merchent.location = responseData;
      // } else if (locationType == 'MerchantManagedLocation') {
      //   loggedIn_Merchent.MostRecentManageRealEstateLocation = responseData;
      // } //BUGBUG:NOTE:TODO else block needs to be tought through.
      // //user locatiion should be added for the profile in the else case.
      // else {
      //   loggedIn_Merchent.location = responseData;
      // }
      int locationId = int.tryParse(response.data.toString()) ?? -1;
      // if (locationId == -1) {
      //   snackbarService.showCustomSnackBar(
      //     variant: SnackbarType.error,
      //     message: 'Location registration failed.',
      //   );
      // }
      return locationId;
    }
    // snackbarService.showCustomSnackBar(
    //   variant: SnackbarType.error,
    //   message: 'Location registration failed.',
    // );
    return null;
  }

  // ! Can't find the locationFromAddress method
  // Future<List<double>?> getCityCoordinates(String cityName) async {
  //   if (cityName.isEmpty) {
  //     cityName == "Seattle";
  //   } else {
  //     List<Location> locations = await locationFromAddress(cityName);

  //     if (locations.isNotEmpty) {
  //       double latitude = locations.first.latitude;
  //       double longitude = locations.first.longitude;

  //       List<double> coordinates = [latitude, longitude];
  //       return coordinates; // Return the coordinates array
  //     }
  //   }
  //   return null;
  // }

  Future<int> registerMerchantInPayFacDbGolden(var resourceid) async {
    // Replace with your API base URL
    final String apiUrl =
        '${ApiEndPoints.registerMerchantInPayFacDb}/$resourceid';
    var response = await apiService.get(endPoint: apiUrl);
    int merchantId = int.tryParse(response.data.toString()) ?? -1;
    return merchantId;
  }

  Future<User?> getUserById(String userId) async {
    final String url = '${ApiEndPoints.getUserById}/$userId';
    var response = await apiService.get(endPoint: url);
    if (response.success) {
      final Map<String, dynamic> userData = response.data;
      return User.fromGetUserByIdMap(userData);
    }
    return null;
  }

  Future<int?> getUserIdByEmail(String email) async {
    final String url = '${ApiEndPoints.getUserByEmail}/$email';

    var response = await apiService.get(endPoint: url);
    if (response.success) {
      final Map<String, dynamic> userData = response.data;
      //printing the LoggedIn user details
      return userData['GetUserByIdResult']['UserId'];
    }
    return null;
  }

  ///Returns bankId
  Future<String> addBankNamesDetailedGolden(String bankName) async {
    final String url = '${ApiEndPoints.addBankNamesDetailed}/$bankName';
    var response = await apiService.get(endPoint: url);
    return response.data.toString();
  }

  Future<RequestResponse> addBankAccountDetailedGolden(
    String bankID,
    String ddaType, // Checking, Savings
    String achType, //CommercialChecking, PrivateChecking
    String accountNumber,
    String routingNumber,
    int mID, //Get from registerMerchantInPayFacDbGolden
    int id, // Get from registerUserWithPhoneNumberGolden
  ) async {
    final String url =
        '${ApiEndPoints.addBankAccountDetailed}/$bankID/$ddaType/$achType/$accountNumber/$routingNumber/$mID/$id'; //UserregsirationID1 is merchantId sent from the previous screen

    var response = await apiService.get(endPoint: url);

    if (response.success) {
      // final dynamic responseData = response.data;
      // loggedIn_Merchent.AddBankAccountDetailedId = responseData;
    }
    return response;
  }

  Future<List<PayFacsResult>> getPayFacsGolden() async {
    try {
      const String url = ApiEndPoints.getAllPayFacs;

      // final prefs = await SharedPreferences.getInstance();
      // payfacsLocal = prefs.getString('payFacsData');
      // print(payfacsLocal);

      // if (payfacsLocal != null && payfacsLocal!.isNotEmpty) {
      //   final List<dynamic> data = json.decode(payfacsLocal!);
      //   Payfacs_Global =
      //       data.map((item) => GetAllPayFacsResult.fromJson(item)).toList();
      //   return Payfacs_Global;
      // } else
      // {
      final apiData = await apiService.get(endPoint: url);
      if (apiData.success && apiData.data['GetAllPayFacsResult'] != null) {
        final List<dynamic> data = apiData.data['GetAllPayFacsResult'];
        List<PayFacsResult> payfacs =
            data.map((item) => PayFacsResult.fromMap(item)).toList();
        // prefs.setString('payFacsData', json.encode(data));
        return payfacs;
        // } else {
        //   throw Exception('Failed to fetch user data ${apiData.returnCode}');
        // }
      }
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
    return [];
  }

  Future<int> registerProfessional(
    String ownerID, //UserId
    String
        category, //healthCare, trucking, realEstate, resturants, b2b, professionalServices, travelAndEntertainment, government, education.
    String
        type, //doctor, nurse, driver, realEstateAgent, realEstateBroker, realEstateManager, realEstateOwner, realEstateTenant, realEstateVendor, realEstateBuyer, realEstateSeller, realEstateLender, realEstateLandlord, realEstateTenantRep, realEstateLandlordRep, realEstateTenantRepBroker, realEstateLandlordRepBroker, realEstateTenantRepAgent, realEstateLandlordRepAgent, realEstateTenantRepManager, realEstateLandlordRepManager, realEstateTenantRepOwner, realEstateLandlordRepOwner, realEstateTenantRepVendor, realEstateLandlordRepVendor, realEstateTenantRepBuyer, realEstateLandlordRepBuyer, realEstateTenantRepSeller, realEstateLandlordRepSeller
    String companyId, //MerchantId
    String idType, //Passport, CNIC, StateID
    String idNumber,
    String idExpiryDate,
    String idIssuingState,
    String idIssuingCountry,
    String licenseNumber,
    String licenseType, //Free text
    String licenseExpiryDate,
    String licenseIssuingState,
    String licenseIssuingCountry,
    String gender,
    String dob,
    String locationId, //-1 if not available
  ) async {
    String formattedIdExpiryDate = DateTimeService.mmddyyyyFormat(idExpiryDate);
    String formattedLicenseExpiryDate =
        DateTimeService.mmddyyyyFormat(licenseExpiryDate);
    String formattedDob = DateTimeService.mmddyyyyFormat(dob);
    final String url =
        '${ApiEndPoints.registerProfessional}/$ownerID/$category/$type/$companyId/$idType/$idNumber/$formattedIdExpiryDate/$idIssuingState/$idIssuingCountry/$licenseType/$licenseNumber/$formattedLicenseExpiryDate/$licenseIssuingState/$licenseIssuingCountry/$gender/$formattedDob/$locationId'; //UserregsirationID1 is merchantId sent from the previous screen

    var response = await apiService.get(endPoint: url);

    int professionalId = int.tryParse(response.data.toString()) ?? -1;
    return professionalId;
  }

  /// For merchant services, Provider is the merchantId, Customer and Resource /Schedule  / Location IDs are all -1
  /// For professional services (under a merchant), the providerid will be the professional ID while customer /Resource and schedule id will be -1
  Future<int> addNewService(
    String name,
    String type, // Free form
    String resourceID, //-1
    String serviceLocationId, //-1
    String pickupLocationId, //-1
    String dropoffLocationId, //-1
    String cost, // Free form number
    String customerId, //-1
    String providerId, //Professional Id or Merchant Id
    String scheduleId, //-1
  ) async {
    final String url =
        '${ApiEndPoints.addNewService}/$name/$type/$resourceID/$serviceLocationId/$pickupLocationId/$dropoffLocationId/$cost/$customerId/$providerId/$scheduleId';
    var response = await apiService.get(endPoint: url);
    var data = response.data['AddNewServiceResult'];
    int serviceId = int.tryParse(data.toString()) ?? -1;
    return serviceId;
  }

  Future<List<Map<String, dynamic>>?> getServiceByProviderId(
    String serviceProviderId,
  ) async {
    final String url =
        '${ApiEndPoints.getServiceByProviderId}/$serviceProviderId';
    var response = await apiService.get(endPoint: url);
    if (response.success) {
      final List<dynamic>? services =
          response.data['GetServiceByProviderIdResult'];
      if (services != null) {
        List<Map<String, dynamic>> serviceList =
            services.map((e) => e as Map<String, dynamic>).toList();
        return serviceList;
      }
    }
    return null;
  }

  Future<List<ServiceModel>?> getServiceObjectsByProviderId(
      String providerId) async {
    final String url =
        '${ApiEndPoints.getServiceObjectsByProviderId}/$providerId';
    var response = await apiService.get(endPoint: url);
    if (response.success) {
      final List<dynamic>? services =
          response.data['GetServiceObjectsByProviderIdResult'];
      if (services != null) {
        List<ServiceModel> serviceList =
            services.map((e) => ServiceModel.fromMap(e)).toList();
        return serviceList;
      }
    }
    return null;
  }

  /// For now get currency from your resource valueation
  /// where resourceid is the professional Id for which you are adding rate.
  Future<String> addRate(
    String resourceId,
    String timeUnit,
    String minUnits,
    String maxUnits,
    String rate,
  ) async {
    final String url =
        '${ApiEndPoints.addRate}/$resourceId/$timeUnit/$minUnits/$maxUnits/$rate';
    var response = await apiService.get(endPoint: url);
    return response.data.toString();
  }

  Future<String> requestSpecificService(
    String serviceId,
    String resourceId,
    String serviceLocationId,
    String requestorId,
    String yearStart,
    String monthStart,
    String dayStart,
    String hourStart,
    String minuteStart,
    String secondStart,
    String millisecondStart,
    String yearEnd,
    String monthEnd,
    String dayEnd,
    String hourEnd,
    String minuteEnd,
    String secondEnd,
    String millisecondEnd,
  ) async {
    final String url =
        '${ApiEndPoints.requestSpecificService}/$serviceId/$resourceId/$serviceLocationId/$requestorId/$yearStart/$monthStart/$dayStart/$hourStart/$minuteStart/$secondStart/$millisecondStart/$yearEnd/$monthEnd/$dayEnd/$hourEnd/$minuteEnd/$secondEnd/$millisecondEnd';
    var response = await apiService.get(endPoint: url);
    return response.data.toString();
  }

  Future<List<Map<String, dynamic>>> getProfessionalsOfACompany(
    String companyId,
    String category,
    String type,
  ) async {
    final String url =
        '${ApiEndPoints.getProfessionalsOfACompany}/$companyId/$category/$type';
    var response = await apiService.get(endPoint: url);
    if (response.success) {
      final List<dynamic> professionals = response.data;
      List<Map<String, dynamic>> professionalList =
          professionals.map((e) => e as Map<String, dynamic>).toList();
      return professionalList;
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getIndependentProfessionals(
    String type,
  ) async {
    final String url = '${ApiEndPoints.getIndependentProfessionals}/$type';
    var response = await apiService.get(endPoint: url);
    if (response.success) {
      final List<dynamic> professionals =
          response.data["GetIndependentProfessionalsResult"];
      List<Map<String, dynamic>> professionalList =
          professionals.map((e) => e as Map<String, dynamic>).toList();
      return professionalList;
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getDriversOfACompany(
    String companyId,
  ) async {
    final String url = '${ApiEndPoints.getDriversOfACompany}/$companyId';
    var response = await apiService.get(endPoint: url);
    if (response.success) {
      final List<dynamic> drivers = response.data;
      List<Map<String, dynamic>> driverList =
          drivers.map((e) => e as Map<String, dynamic>).toList();
      return driverList;
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getIndependentDrivers(
    String type,
  ) async {
    final String url = '${ApiEndPoints.getIndependentDrivers}/$type';
    var response = await apiService.get(endPoint: url);
    if (response.success) {
      final List<dynamic> drivers = response.data;
      List<Map<String, dynamic>> driverList =
          drivers.map((e) => e as Map<String, dynamic>).toList();
      return driverList;
    }
    return [];
  }

  Future<String> registerUserDetailed(
    String firstName,
    String lastName,
    String userName,
    String emailAddress,
    String cellPhoneNumber,
    String city,
    String state,
    String country,
    String password,
    String isActive,
  ) async {
    final String url =
        '${ApiEndPoints.registerUserDetailed}/$firstName/$lastName/$userName/$emailAddress/$cellPhoneNumber/$city/$state/$country/$password/$isActive';
    var response = await apiService.get(endPoint: url);
    return response.data.toString();
  }

  Future<int> registerDriver(
      String ownerID,
      String category,
      String type,
      String truckingCompanyID,
      String idType,
      String idNumber,
      String idExpiryDate,
      String idIssuingState,
      String idIssuingCountry,
      String drivingLicenseType,
      String drivingLicenseNumber,
      String drivingLicenseExpiryDate,
      String drivingLicenseIssuingState,
      String drivingLicenseIssuingCountry) async {
    final String url =
        '${ApiEndPoints.registerDriver}/$ownerID/$category/$type/$truckingCompanyID/$idType/$idNumber/$idExpiryDate/$idIssuingState/$idIssuingCountry/$drivingLicenseType/$drivingLicenseNumber/$drivingLicenseExpiryDate/$drivingLicenseIssuingState/$drivingLicenseIssuingCountry';
    var response = await apiService.get(endPoint: url);
    int driverId = int.tryParse(response.data.toString()) ?? -1;
    return driverId;
  }

  Future<String> setResourceProperty(
    String propertyName,
    String propertyValue,
    String resourceID,
  ) async {
    final String url =
        '${ApiEndPoints.setResourceProperty}/$propertyName/$propertyValue/$resourceID';
    var response = await apiService.get(endPoint: url);
    return response.data.toString();
  }

  Future<List<Map<String, dynamic>>> getVehiclesOfACompany(
    String companyId,
  ) async {
    final String url = '${ApiEndPoints.getVehiclesOfACompany}/$companyId';
    var response = await apiService.get(endPoint: url);
    if (response.success) {
      final List<dynamic> vehicles = response.data;
      List<Map<String, dynamic>> vehicleList =
          vehicles.map((e) => e as Map<String, dynamic>).toList();
      return vehicleList;
    }
    return [];
  }

  Future<String> registerTransaction(
    String orderNumber,
    String transactionType,
    String transactionRefId,
    String processor,
    String environment,
    String gatewayResponse,
  ) async {
    final String url =
        '${ApiEndPoints.registerTransaction}/$orderNumber/$transactionType/$transactionRefId/$processor/$environment/$gatewayResponse';
    var response = await apiService.get(endPoint: url);
    return response.data.toString();
  }

  Future<List<Map<String, dynamic>>> getTransactionByTransactionRefIDProcessor(
    String transactionRefIdProcessor,
  ) async {
    final String url =
        '${ApiEndPoints.getTransactionByTransactionRefIDProcessor}/$transactionRefIdProcessor';
    var response = await apiService.get(endPoint: url);
    if (response.success) {
      final List<dynamic> transactions = response.data;
      List<Map<String, dynamic>> transactionList =
          transactions.map((e) => e as Map<String, dynamic>).toList();
      return transactionList;
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getResourceHistory(
    String resourceID,
  ) async {
    final String url = '${ApiEndPoints.getResourceHistory}/$resourceID';
    var response = await apiService.get(endPoint: url);
    if (response.success) {
      final List<dynamic> history = response.data;
      List<Map<String, dynamic>> historyList =
          history.map((e) => e as Map<String, dynamic>).toList();
      return historyList;
    }
    return [];
  }

  Future<int> registerTruck(
    String ownerID,
    String category,
    String type,
    String truckingCompanyID,
    String idType,
    String make,
    String model,
    String year,
    String vin,
    String length,
    String registrationNumber,
    String registrationValiditiy,
    String plateNumber,
    String insuranceValidityDate,
    String portName,
    String permitNumber,
    String permitExpiryDate,
  ) async {
    final String url =
        '${ApiEndPoints.registerTruck}/$ownerID/$category/$type/$truckingCompanyID/$idType/$make/$model/$year/$vin/$length/$registrationNumber/$registrationValiditiy/$plateNumber/$insuranceValidityDate/$portName/$permitNumber/$permitExpiryDate';
    var response = await apiService.get(endPoint: url);
    int truckId = int.tryParse(response.data.toString()) ?? -1;
    return truckId;
  }

  Future<int> addBankCardDetailed(
    String customerId,
    String cardType, // Visa, MasterCard, AmericanExpress, Discover
    String cardNumber,
    String expiryMonth,
    String expiryYear,
    String cvv,
    String nameOnCard,
    String locationId,
  ) async {
    final String url =
        '${ApiEndPoints.addBankCardDetailed}/$customerId/$cardType/$cardNumber/$expiryMonth/$expiryYear/$cvv/$nameOnCard/$locationId';
    var response = await apiService.get(endPoint: url);
    int cardId = int.tryParse(response.data.toString()) ?? -1;
    return cardId;
  }

  Future<List<ServiceModel>?> getAllAvailableServicesByCategory(
      String category) async {
    final String url =
        '${ApiEndPoints.getAllAvailableServicesByCategory}/$category';
    var response = await apiService.get(endPoint: url);
    List<dynamic>? data =
        response.data['GetAllAvailableServicesByCategoryResult'];

    if (data != null) {
      List<ServiceModel> services =
          data.map((item) => ServiceModel.fromMap(item)).toList();
      return services;
    }
    return null;
  }

  Future<int?> registerPatient(
    String ownerId,
    String category,
    String type,
    String companyId,
    String mrn,
    String idType,
    String idNumber,
    String idExpiry,
    String idIssuingState,
    String idIssuingCountry,
    String gender,
    String dob,
    String locationId,
  ) async {
    String formattedIdExpiryDate = DateTimeService.mmddyyyyFormat(idExpiry);
    String formattedDob = DateTimeService.mmddyyyyFormat(dob);
    final String url =
        '${ApiEndPoints.registerPatient}/$ownerId/$category/$type/$companyId/$mrn/$idType/$idNumber/$formattedIdExpiryDate/$idIssuingState/$idIssuingCountry/$gender/$formattedDob/$locationId';
    var response = await apiService.get(endPoint: url);
    if (response.success) {
      final dynamic responseData = response.data;
      int patientId = int.tryParse(responseData.toString()) ?? -1;
      return patientId;
    }
    return null;
  }

  Future<List<int>?> findResourceEfficient(
      String search, String category) async {
    final String url =
        '${ApiEndPoints.findResourceEfficient}/$search/$category';
    var response = await apiService.get(endPoint: url);
    if (response.success) {
      final List<dynamic> data = response.data['FindResourceEfficientResult'];
      List<int> resourceIds =
          data.map((e) => int.tryParse(e.toString()) ?? -1).toList();
      return resourceIds;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getProfessionalById(String id) async {
    final String url =
        '${ApiEndPoints.getAppObjectProfessionalById}/$id/"false';
    var response = await apiService.get(endPoint: url);
    if (response.success) {
      return response.data['GetAppObjectProfessionalByIdResult'];
    }
    return null;
  }

  Future<bool> updateUserDetailed(
    String userId,
    String firstName,
    String lastName,
    String userName,
    String emailAddress,
    String cellPhoneNumber,
    String address,
    String apartmentNumber,
    String city,
    String state,
    String country,
  ) async {
    final String url =
        '${ApiEndPoints.updateUserDetailed}/$userId/$firstName/$lastName/$userName/$emailAddress/$cellPhoneNumber/$address/$apartmentNumber/$city/$state/$country';
    var response = await apiService.get(endPoint: url);
    if (response.success) {
      return response.data ?? false;
    }
    return false;
  }

  Future<String?> updatePassword(
    String email,
    String currentPassword,
    String newPassword,
  ) async {
    final String url =
        '${ApiEndPoints.updatePassword}/$email/$currentPassword/$newPassword';
    var response = await apiService.get(endPoint: url);
    if (response.success) {
      return response.data['UpdatePasswordResult'];
    }
    return null;
  }

  Future<String?> forgotPassword(
    String email,
  ) async {
    final String url = '${ApiEndPoints.forgotPassword}/$email';
    var response = await apiService.get(endPoint: url);
    if (response.success) {
      return response.data;
    }
    return null;
  }

  Future<String?> contactUs(
    String name,
    String contactNumber,
    String email,
    String query,
  ) async {
    final String url =
        '${ApiEndPoints.contactUs}/$name/$contactNumber/$email/$query';
    var response = await apiService.get(endPoint: url);
    if (response.success) {
      return response.data['ContactUsResult'];
    }
    return null;
  }

  Future<List<ServiceModel>?> searchServices(
    String search,
    String minPrice,
    String maxPrice,
  ) async {
    final String url =
        '${ApiEndPoints.searchServices}/$search/$minPrice/$maxPrice';
    var response = await apiService.get(endPoint: url);
    List<dynamic>? data = response.data['SearchServicesResult'];
    if (data != null) {
      List<ServiceModel> services =
          data.map((item) => ServiceModel.fromMap(item)).toList();
      return services;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> findResourceAvailabilityInAMonth(
    String resourceId,
    String month,
    String year,
  ) async {
    final String url =
        '${ApiEndPoints.findResourceAvailabilityInAMonth}/$resourceId/$month/$year';
    var response = await apiService.get(endPoint: url);
    if (response.success) {
      final List<dynamic> data =
          response.data['FindResourceAvailabilityInAMonthResult'];
      List<Map<String, dynamic>> availabilityList =
          data.map((e) => e as Map<String, dynamic>).toList();
      return availabilityList;
    }
    return [];
  }

  Future<dynamic> registerOwner(
    String resourceID,
    String payFacDbMerchantID,
    String ownerType,
    String firstName,
    String middleName,
    String lastName,
    String phoneNumber,
    String phoneNumberExt,
    String faxNumber,
    String email,
    String ownershipPercentage,
    String ssnOrItin,
    String dobYear,
    String dobMonth,
    String dobDay,
    String addressLine1,
    String city,
    String state,
    String country,
    String postalCode,
    String postalCodeExt,
  ) async {
    final String url =
        '${ApiEndPoints.registerOwner}/$resourceID/$payFacDbMerchantID/$ownerType/$firstName/$middleName/$lastName/$phoneNumber/$phoneNumberExt/$faxNumber/$email/$ownershipPercentage/$ssnOrItin/$dobYear/$dobMonth/$dobDay/$addressLine1/$city/$state/$country/$postalCode/$postalCodeExt';
    var response = await apiService.get(endPoint: url);
    return response.data;
  }
}
