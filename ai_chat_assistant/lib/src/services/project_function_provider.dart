import 'package:fin_api_functions/fin_api_functions.dart';
import '../config/project_type.dart';
import '../config/chat_agent_config.dart';
import 'openai_service.dart';

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
      case ProjectType.shifa:
        return _getShifaFunctionDefinitions();
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
      case ProjectType.shifa:
        return await _executeShifaFunction(functionName, args);
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

  /// Shifa function definitions
  List<Map<String, dynamic>> _getShifaFunctionDefinitions() {
    return [
      {
        "name": "get_all_services",
        "description": "Get all healthcare services available in the system",
        "parameters": {
          "type": "object",
          "properties": {},
          "required": [],
        }
      },
      {
        "name": "get_appointments",
        "description": "Get appointments of the currently logged-in user",
        "parameters": {
          "type": "object",
          "properties": {
            "user_id": {
              "type": "string",
              "description":
                  "The unique identifier of the currently logged-in user"
            }
          },
          "required": ["user_id"]
        }
      },
      {
        "name": "get_current_user_id",
        "description":
            "Get the current logged-in user's ID and basic information",
        "parameters": {"type": "object", "properties": {}, "required": []}
      },
      {
        "name": "get_appointment_records",
        "description":
            "Get the current logged-in user's previous appointment records",
        "parameters": {
          "type": "object",
          "properties": {
            "user_id": {
              "type": "string",
              "description":
                  "The unique identifier of the currently logged-in user"
            }
          },
          "required": ["user_id"],
        }
      },
      {
        "name": "find_resource_availability_in_a_month",
        "description":
            "Get the availability of medical resources (e.g., doctors, equipment) for re-scheduling appointments in a specific month",
        "parameters": {
          "type": "object",
          "properties": {
            "resource_id": {
              "type": "string",
              "description":
                  "The unique identifier of the medical resource (e.g., doctor ID)"
            },
            "month": {
              "type": "string",
              "description":
                  "The month for which to check availability in MM format"
            },
            "year": {
              "type": "string",
              "description":
                  "The year for which to check availability in YYYY format"
            },
          },
          "required": ["resource_id", "month", "year"],
        }
      },
      {
        "name": "reshedule_appointment",
        "description":
            "Reschedule an existing appointment for the user, Ask user for rescheduling date and time and check availability first using find_resource_availability_in_a_month function before calling this function",
        "parameters": {
          "type": "object",
          "properties": {
            "appointment_id": {
              "type": "string",
              "description":
                  "The unique identifier of the appointment to be rescheduled"
            },
            "year_start": {
              "type": "string",
              "description":
                  "The start year for the new appointment date in YYYY format"
            },
            "month_start": {
              "type": "string",
              "description":
                  "The start month for the new appointment date in MM format"
            },
            "day_start": {
              "type": "string",
              "description":
                  "The start day for the new appointment date in DD format"
            },
            "hour_start": {
              "type": "string",
              "description":
                  "The start hour for the new appointment time in HH format (24-hour clock)"
            },
            "minute_start": {
              "type": "string",
              "description":
                  "The start minute for the new appointment time in MM format"
            },
            "second_start": {
              "type": "string",
              "description":
                  "The start second for the new appointment time in SS format"
            },
            "millisecond_start": {
              "type": "string",
              "description":
                  "The start millisecond for the new appointment time in SSS format"
            },
            "year_end": {
              "type": "string",
              "description":
                  "The end year for the new appointment date in YYYY format"
            },
            "month_end": {
              "type": "string",
              "description":
                  "The end month for the new appointment date in MM format"
            },
            "day_end": {
              "type": "string",
              "description":
                  "The end day for the new appointment date in DD format"
            },
            "hour_end": {
              "type": "string",
              "description":
                  "The end hour for the new appointment time in HH format (24-hour clock)"
            },
            "minute_end": {
              "type": "string",
              "description":
                  "The end minute for the new appointment time in MM format"
            },
            "second_end": {
              "type": "string",
              "description":
                  "The end second for the new appointment time in SS format"
            },
            "millisecond_end": {
              "type": "string",
              "description":
                  "The end millisecond for the new appointment time in SSS format"
            },
          },
          "required": [
            "appointment_id",
            "year_start",
            "month_start",
            "day_start",
            "hour_start",
            "minute_start",
            "second_start",
            "millisecond_start",
            "year_end",
            "month_end",
            "day_end",
            "hour_end",
            "minute_end",
            "second_end",
            "millisecond_end"
          ],
        }
      },
      {
        "name": "cancel_appointment",
        "description": "Cancel an existing appointment for the user",
        "parameters": {
          "type": "object",
          "properties": {
            "appointment_id": {
              "type": "string",
              "description":
                  "The unique identifier of the appointment to be canceled"
            }
          },
          "required": ["appointment_id"],
        }
      },
      {
        "name": "delete_appointment",
        "description": "Delete an existing appointment for the user",
        "parameters": {
          "type": "object",
          "properties": {
            "appointment_id": {
              "type": "string",
              "description":
                  "The unique identifier of the appointment to be deleted"
            }
          },
          "required": ["appointment_id"],
        }
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

  /// Execute Shifa specific functions
  Future<Map<String, dynamic>> _executeShifaFunction(
    String functionName,
    Map<String, dynamic> args,
  ) async {
    try {
      switch (functionName) {
        case 'get_all_services':
          final services = await apiFunctionsService
              .getAllAvailableServicesByCategory('healthcare');
          if (services != null) {
            final servicesData =
                services.map((service) => service.toMap()).toList();
            return {
              'success': true,
              'services': servicesData,
              'count': services.length,
              'message': 'Healthcare services retrieved successfully'
            };
          }
          return {
            'success': false,
            'services': [],
            'count': 0,
            'message': 'No healthcare services found'
          };

        case 'get_appointments':
          final userId = args['user_id'];
          final appointments =
              await apiFunctionsService.getAppointments(userId);

          return {
            'success': true,
            'appointments': appointments,
            'count': appointments.length,
            'message': 'Appointments retrieved successfully'
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
        case 'get_appointment_records':
          final userId = args['user_id'];
          final records =
              await apiFunctionsService.getAppointmentsRecord(userId);
          return {
            'success': true,
            'records': records,
            'count': records.length,
            'message': 'Appointment records retrieved successfully'
          };

        case 'find_resource_availability_in_a_month':
          final resourceId = args['resource_id'];
          final month = args['month'];
          final year = args['year'];
          final availability = await apiFunctionsService
              .findResourceAvailabilityInAMonth(resourceId, month, year);
          return {
            'success': true,
            'availability': availability.map((e) => e.toMap()).toList(),
            'count': availability.length,
            'message': 'Resource availability retrieved successfully'
          };
        case 'reshedule_appointment':
          final appointmentId = args['appointment_id'];
          final yearStart = args['year_start'];
          final monthStart = args['month_start'];
          final dayStart = args['day_start'];
          final hourStart = args['hour_start'];
          final minuteStart = args['minute_start'];
          final secondStart = args['second_start'];
          final millisecondStart = args['millisecond_start'];
          final yearEnd = args['year_end'];
          final monthEnd = args['month_end'];
          final dayEnd = args['day_end'];
          final hourEnd = args['hour_end'];
          final minuteEnd = args['minute_end'];
          final secondEnd = args['second_end'];
          final millisecondEnd = args['millisecond_end'];
          final result = await apiFunctionsService.rescheduleAppointment(
            appointmentId,
            yearStart,
            monthStart,
            dayStart,
            hourStart,
            minuteStart,
            secondStart,
            millisecondStart,
            yearEnd,
            monthEnd,
            dayEnd,
            hourEnd,
            minuteEnd,
            secondEnd,
            millisecondEnd,
          );
          return {
            'success': result,
            'message': result
                ? 'Appointment rescheduled successfully'
                : 'Failed to reschedule appointment'
          };
        case 'cancel_appointment':
          final appointmentId = args['appointment_id'];
          final result =
              await apiFunctionsService.cancelAppointment(appointmentId);
          return {
            'success': result,
            'message': result
                ? 'Appointment canceled successfully'
                : 'Failed to cancel appointment'
          };
        case 'delete_appointment':
          final appointmentId = args['appointment_id'];
          final result =
              await apiFunctionsService.deleteAppointment(appointmentId);
          return {
            'success': result,
            'message': result
                ? 'Appointment deleted successfully'
                : 'Failed to delete appointment'
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
