import 'package:ai_chat_assistant/ai_chat_assistant.dart';
import 'package:fin_api_functions/fin_api_functions.dart';

/// Project-specific function provider that integrates with fin_api_functions
class ProjectFunctionProvider implements FunctionDefinitionsProvider {
  final ProjectType projectType;
  final ApiFunctionsService apiFunctionsService;
  final ChatAgentConfig? config;

  ProjectFunctionProvider({
    required this.projectType,
    required this.apiFunctionsService,
    this.config,
  });

  /// Get function definitions based on project type
  List<Map<String, dynamic>> getFunctionDefinitions() {
    switch (projectType) {
      case ProjectType.realEstate:
        return _getRealEstateFunctionDefinitions();
    }
  }

  /// Execute a function based on project type
  Future<Map<String, dynamic>> executeFunction(
    String functionName,
    Map<String, dynamic> args,
  ) async {
    switch (projectType) {
      case ProjectType.realEstate:
        return await _executeRealEstateFunction(functionName, args);
    }
  }

  /// Real Estate function definitions
  List<Map<String, dynamic>> _getRealEstateFunctionDefinitions() {
    return [
      {
        "name": "get_total_outstanding_balance",
        "description":
            "Get the total outstanding balance for a specific user across all their properties and services",
        "parameters": {
          "type": "object",
          "properties": {
            "user_id": {
              "type": "string",
              "description":
                  "The unique identifier of the user for whom to retrieve the total outstanding balance"
            }
          },
          "required": ["user_id"]
        }
      },
      {
        "name": "get_all_real_estate",
        "description":
            "Get all real estate properties managed by a specific sub-merchant with detailed information",
        "parameters": {
          "type": "object",
          "properties": {
            "sub_merchant_id": {
              "type": "string",
              "description":
                  "The unique identifier of the sub-merchant whose real estate properties should be retrieved"
            }
          },
          "required": ["sub_merchant_id"]
        }
      },
      {
        "name": "get_current_user_id",
        "description":
            "Get the current logged-in user's ID and basic information",
        "parameters": {"type": "object", "properties": {}, "required": []}
      },
      {
        "name": "get_my_outstanding_balance",
        "description":
            "Get the total outstanding balance for the current logged-in user",
        "parameters": {"type": "object", "properties": {}, "required": []}
      }
    ];
  }

  /// Execute Real Estate specific functions
  Future<Map<String, dynamic>> _executeRealEstateFunction(
    String functionName,
    Map<String, dynamic> args,
  ) async {
    try {
      switch (functionName) {
        case 'get_total_outstanding_balance':
          final userId = args['user_id'];
          final balance =
              await apiFunctionsService.getTotalOutstandingBalance(userId);
          return {
            'success': true,
            'balance': balance,
            'currency': 'USD',
            'message': 'Total outstanding balance retrieved successfully'
          };

        case 'get_all_real_estate':
          final subMerchantId = args['sub_merchant_id'];
          final properties =
              await apiFunctionsService.getAllRealEstate(subMerchantId);

          // Transform the properties to a more chat-friendly format
          final propertiesData = properties
              .map((property) => {
                    'id': property.id,
                    'address': property.address,
                    'category': property.category,
                    'type': property.type,
                    'rent': property.rent,
                    'price': property.price,
                    'fees': property.fees,
                    'isLeased': property.isLeased,
                    'friendlyName': property.friendlyName,
                    'starRating': property.starRating,
                    'state': property.state,
                    'country': property.country,
                    'locationId': property.locationId,
                    'managementCompanyId': property.managementCompanyId
                  })
              .toList();

          return {
            'success': true,
            'properties': propertiesData,
            'count': propertiesData.length,
            'message': 'Real estate properties retrieved successfully'
          };

        case 'get_current_user_id':
          // Use config's getCurrentUser if provided
          final currentUserData = config?.getCurrentUser != null
              ? await config!.getCurrentUser!()
              : null;

          if (currentUserData == null) {
            return {'success': false, 'error': 'User is not logged in'};
          }

          return {
            'success': true,
            ...currentUserData,
            'message': 'Current user information retrieved successfully'
          };

        case 'get_my_outstanding_balance':
          // Use config's getCurrentUser if provided
          final currentUserData = config?.getCurrentUser != null
              ? await config!.getCurrentUser!()
              : null;

          if (currentUserData == null) {
            return {'success': false, 'error': 'User is not logged in'};
          }

          final userId = currentUserData['userId']?.toString();
          if (userId == null) {
            return {'success': false, 'error': 'User ID not found'};
          }

          final balance =
              await apiFunctionsService.getTotalOutstandingBalance(userId);

          return {
            'success': true,
            'balance': balance,
            'currency': 'USD',
            'userId': userId,
            'message':
                'Outstanding balance retrieved successfully for current user'
          };

        default:
          return {'error': 'Unknown function: $functionName'};
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to execute function: ${_getErrorMessage(e)}'
      };
    }
  }

  /// Get error message from exception
  String _getErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return 'An unexpected error occurred';
  }
}
