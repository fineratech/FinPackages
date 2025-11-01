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

    // Convert to Realtime API tool format
    return projectFunctions.map((func) {
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
    return await projectFunctionProvider.executeFunction(functionName, args);
  }
}
