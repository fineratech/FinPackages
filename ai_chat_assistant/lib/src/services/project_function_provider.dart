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
        "description":
            "Get all upcoming and past appointments of the currently logged-in user. Use this when user asks to 'see my appointments', 'view my bookings', 'show my schedule', or wants to reschedule/cancel an existing appointment. This shows existing appointments only - it does NOT create new appointments.",
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
                  "The unique identifier of the medical resource (e.g., doctor ID professional ID) to check availability for. Prefer professional ID or resource id over user ID."
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
            "ONLY use this to reschedule an EXISTING appointment that the user already has. This is NOT for booking new appointments. Ask user for rescheduling date and time and check availability first using find_resource_availability_in_a_month function before calling this function. The user must explicitly say they want to reschedule or change an existing appointment.",
        "parameters": {
          "type": "object",
          "properties": {
            "appointment_id": {
              "type": "string",
              "description":
                  "The unique identifier of the appointment to be rescheduled, which was provided earlier in the conversation using get_appointments function, don't use dummy ids like 0 etc. Only use valid appointment ids."
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
      },
      {
        "name": "get_current_date",
        "description": "Get the current date to compare with appointment dates",
        "parameters": {"type": "object", "properties": {}, "required": []}
      },
      {
        "name": "get_all_therapists",
        "description":
            "Get all available therapists/healthcare professionals in the system. Use this as the FIRST STEP when a user wants to book/schedule a NEW appointment. This will help the user choose which therapist they want to see. Keywords: 'book appointment', 'schedule appointment', 'make appointment', 'see a therapist', 'I need therapy'.",
        "parameters": {
          "type": "object",
          "properties": {},
          "required": [],
        }
      },
      {
        "name": "get_services_by_therapist",
        "description":
            "Get all services offered by a specific therapist. Use this after user selects a therapist to show what services they can book.",
        "parameters": {
          "type": "object",
          "properties": {
            "therapist_id": {
              "type": "string",
              "description":
                  "The unique identifier of the therapist/healthcare professional, professional ID obtained from get_all_therapists function, not the name"
            }
          },
          "required": ["therapist_id"],
        }
      },
      {
        "name": "schedule_new_appointment",
        "description":
            "Use this to book a NEW appointment (not for rescheduling existing ones). This function handles the complete flow including payment processing and appointment creation. IMPORTANT STEPS TO FOLLOW:\n1. Get all therapists using get_all_therapists\n2. Ask user to select a therapist\n3. Get services for selected therapist using get_services_by_therapist\n4. Ask user to select a service\n5. Check availability using find_resource_availability_in_a_month\n6. Ask user to select a date and time slot\n7. ASK USER: 'How would you like to pay? (card/cash)' - You MUST ask this question before calling this function\n8. Only after getting payment method preference, call this function with all the required information.",
        "parameters": {
          "type": "object",
          "properties": {
            "patient_id": {
              "type": "string",
              "description":
                  "The unique identifier of the patient booking the appointment"
            },
            "therapist_id": {
              "type": "string",
              "description":
                  "The unique identifier of the therapist/healthcare professional"
            },
            "service_id": {
              "type": "string",
              "description": "The unique identifier of the service being booked"
            },
            "service_name": {
              "type": "string",
              "description": "The name of the service being booked"
            },
            "service_location_id": {
              "type": "string",
              "description":
                  "The location ID where the service will be provided"
            },
            "service_cost": {
              "type": "string",
              "description":
                  "The cost of the service in USD (e.g., '50' for \$50)"
            },
            "payment_method": {
              "type": "string",
              "enum": ["cash", "card"],
              "description":
                  "Payment method chosen by the user. You MUST ask the user 'How would you like to pay? (card/cash)' before setting this value. 'cash' = cash on delivery, 'card' = pay now with credit/debit card. NEVER assume the payment method - always ask the user first."
            },
            "year_start": {
              "type": "string",
              "description":
                  "The start year for the appointment date in YYYY format"
            },
            "month_start": {
              "type": "string",
              "description":
                  "The start month for the appointment date (1-12 format, e.g., '3' for March)"
            },
            "day_start": {
              "type": "string",
              "description":
                  "The start day for the appointment date (1-31 format)"
            },
            "hour_start": {
              "type": "string",
              "description":
                  "The start hour for the appointment time in 24-hour format (0-23)"
            },
            "minute_start": {
              "type": "string",
              "description": "The start minute for the appointment time (0-59)"
            },
            "second_start": {
              "type": "string",
              "description": "The start second for the appointment time (0-59)"
            },
            "millisecond_start": {
              "type": "string",
              "description":
                  "The start millisecond for the appointment time (0-999)"
            },
            "year_end": {
              "type": "string",
              "description":
                  "The end year for the appointment date in YYYY format"
            },
            "month_end": {
              "type": "string",
              "description":
                  "The end month for the appointment date (1-12 format)"
            },
            "day_end": {
              "type": "string",
              "description":
                  "The end day for the appointment date (1-31 format)"
            },
            "hour_end": {
              "type": "string",
              "description":
                  "The end hour for the appointment time in 24-hour format (0-23)"
            },
            "minute_end": {
              "type": "string",
              "description": "The end minute for the appointment time (0-59)"
            },
            "second_end": {
              "type": "string",
              "description": "The end second for the appointment time (0-59)"
            },
            "millisecond_end": {
              "type": "string",
              "description":
                  "The end millisecond for the appointment time (0-999)"
            },
          },
          "required": [
            "patient_id",
            "therapist_id",
            "service_id",
            "service_name",
            "service_location_id",
            "service_cost",
            "payment_method",
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
        case 'get_current_date':
          final currentDate = DateTime.now().toIso8601String();
          return {
            'success': true,
            'current_date': currentDate,
            'message': 'Current date retrieved successfully'
          };

        case 'get_all_therapists':
          // Get all therapist IDs first
          final therapistIds = await apiFunctionsService.findResourceEfficient(
            "therapist", // resourceType
            "healthcare", // useCaseType
          );

          if (therapistIds == null || therapistIds.isEmpty) {
            return {
              'success': false,
              'therapists': [],
              'count': 0,
              'message': 'No therapists found'
            };
          }

          // Fetch details for each therapist
          List<Future<Map<String, dynamic>?>> futures = [];
          for (var id in therapistIds) {
            futures.add(apiFunctionsService.getProfessionalById(id.toString()));
          }

          final professionals = await Future.wait(futures);
          final therapistsData = professionals
              .where((professional) => professional != null)
              .toList();

          return {
            'success': true,
            'therapists': therapistsData,
            'count': therapistsData.length,
            'message': 'Therapists retrieved successfully'
          };

        case 'get_services_by_therapist':
          final therapistId = args['therapist_id'];
          final allServices = await apiFunctionsService
              .getAllAvailableServicesByCategory('healthcare');

          if (allServices != null && allServices.isNotEmpty) {
            // Filter services by therapist/resource ID
            final therapistServices = allServices
                .where((service) =>
                    service.resourceId == therapistId ||
                    service.providerId == therapistId)
                .toList();

            final servicesData = therapistServices
                .map((service) => {
                      'service_id': service.serviceId,
                      'name': service.name,
                      'type': service.type,
                      'cost': service.cost,
                      'location_id': service.serviceLocationId,
                      'resource_id': service.resourceId,
                    })
                .toList();

            return {
              'success': true,
              'services': servicesData,
              'count': servicesData.length,
              'therapist_id': therapistId,
              'message':
                  'Services for therapist retrieved successfully. Found ${servicesData.length} service(s).'
            };
          }
          return {
            'success': false,
            'services': [],
            'count': 0,
            'message': 'No services found for this therapist'
          };

        case 'schedule_new_appointment':
          // Extract all parameters
          final patientId = args['patient_id'];
          final therapistId = args['therapist_id'];
          final serviceId = args['service_id'];
          final serviceName = args['service_name'];
          final serviceLocationId = args['service_location_id'];
          final serviceCost = args['service_cost'];
          final paymentMethod = args['payment_method'];

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

          final isCardPayment = paymentMethod == 'card';
          String? paymentIntentId;

          // If card payment is requested, process it first
          if (isCardPayment) {
            if (config?.processStripePayment == null) {
              return {
                'success': false,
                'error':
                    'Card payment is not supported. Please use cash payment method or configure Stripe payment processor.'
              };
            }

            // Process Stripe payment
            final paymentResult =
                await config!.processStripePayment!(serviceCost);

            if (paymentResult['success'] != true) {
              return {
                'success': false,
                'error': paymentResult['error'] ??
                    'Payment failed. Please try again or use cash payment.'
              };
            }

            paymentIntentId = paymentResult['payment_id']?.toString();
          }

          // Step 1: Create shopping cart
          final cartId =
              await apiFunctionsService.getIDForNewShoppingCart(patientId);

          if (cartId.toString().isEmpty || cartId.toString() == '-1') {
            return {
              'success': false,
              'error': 'Failed to create shopping cart'
            };
          }

          // Step 2: Add item to shopping cart
          await apiFunctionsService
              .addNewItemToShoppingCartSimplestComprehensive(
            serviceName,
            patientId,
            "1", // quantity
            serviceId,
            serviceCost,
            cartId.toString(),
          );

          // Step 3: Place order
          final status = isCardPayment ? "PaymentsMade" : "Recieved";
          final methodOfPayment = isCardPayment ? "STRIPE" : "CASH";

          final orderNumber =
              await apiFunctionsService.placeOrderDetailedComprehensive(
            cartId.toString(),
            serviceLocationId,
            serviceLocationId,
            status,
            "OneTime",
            "USD", // currency
            methodOfPayment,
          );

          if (orderNumber == -1) {
            return {'success': false, 'error': 'Failed to place order'};
          }

          // Step 4: Get order number string
          final orderNum =
              await apiFunctionsService.getOrderNumber(orderNumber.toString());

          if (orderNum.isEmpty) {
            return {'success': false, 'error': 'Failed to get order number'};
          }

          // Step 5: Register transaction
          await apiFunctionsService.registerTransaction(
            orderNum,
            isCardPayment ? "stripe" : "cash",
            isCardPayment && paymentIntentId != null
                ? paymentIntentId
                : "NA", // transaction reference (payment intent ID for card)
            isCardPayment ? "Stripe" : "Unknown",
            "Prod", // environment
            "NA",
          );

          // Step 6: Create the appointment
          final requestId = await apiFunctionsService.requestSpecificService(
            serviceId,
            therapistId,
            serviceLocationId,
            patientId,
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

          if (requestId != null && requestId.isNotEmpty) {
            return {
              'success': true,
              'appointment_id': requestId,
              'order_number': orderNum,
              'payment_method': paymentMethod,
              'payment_intent_id': paymentIntentId,
              'service_name': serviceName,
              'cost': serviceCost,
              'appointment_date':
                  '$yearStart-$monthStart-$dayStart $hourStart:$minuteStart',
              'message':
                  'Appointment scheduled successfully! Appointment ID: $requestId, Order: $orderNum'
            };
          } else {
            return {
              'success': false,
              'error':
                  'Payment processed but failed to create appointment. Please contact support with order number: $orderNum'
            };
          }

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
