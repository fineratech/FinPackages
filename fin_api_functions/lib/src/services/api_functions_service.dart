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

  Future<RequestResponse> registerMerchantInPayFacDbGolden(
      var resourceid) async {
    // Replace with your API base URL
    final String apiUrl =
        '${ApiEndPoints.registerMerchantInPayFacDb}/$resourceid';
    var response = await apiService.get(endPoint: apiUrl);
    if (response.success) {
      // final dynamic responseData = response.data;
      // loggedIn_Merchent.registerMerchantInPayFacDbId = responseData;
    }
    return response;
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

  //TODO: add bankname before this
  Future<RequestResponse> addBankAccountDetailedGolden(
    String bankID,
    String ddaType,
    String achType,
    String accountNumber,
    String routingNumber,
    int mID,
    int id,
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
}
