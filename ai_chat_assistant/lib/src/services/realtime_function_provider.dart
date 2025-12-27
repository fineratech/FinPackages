import 'project_function_provider.dart';

/// Function provider for OpenAI Realtime API
/// Adapts project-specific functions to Realtime API format
class RealtimeFunctionProvider {
  final ProjectFunctionProvider projectFunctionProvider;

  RealtimeFunctionProvider({
    required this.projectFunctionProvider,
  });

  /// Get function definitions in Realtime API format
  List<Map<String, dynamic>> getFunctionDefinitions() {
    final projectFunctions = projectFunctionProvider.getFunctionDefinitions();

    // Add the end_session function
    final allFunctions = [
      ...projectFunctions,
      {
        'name': 'end_session',
        'description':
            'End the current conversation session. Call this function when the user wants to exit, says goodbye, or indicates they are done with the conversation.',
        'parameters': {
          'type': 'object',
          'properties': {
            'farewell_message': {
              'type': 'string',
              'description':
                  'A brief, friendly farewell message to say to the user before ending the session',
            },
          },
          'required': ['farewell_message'],
        },
      },
    ];

    // Convert to Realtime API tool format
    return allFunctions.map((func) {
      return {
        'type': 'function',
        'name': func['name'],
        'description': func['description'],
        'parameters': func['parameters'],
      };
    }).toList();
  }

  /// Execute a function
  Future<Map<String, dynamic>> executeFunction(
    String functionName,
    Map<String, dynamic> args,
  ) async {
    // Handle the end_session function locally
    if (functionName == 'end_session') {
      final farewellMessage = args['farewell_message'] as String? ?? 'Goodbye!';
      return {
        'status': 'session_ending',
        'message': farewellMessage,
      };
    }

    return await projectFunctionProvider.executeFunction(functionName, args);
  }
}
