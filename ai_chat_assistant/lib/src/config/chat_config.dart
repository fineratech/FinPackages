import 'package:fin_api_functions/fin_api_functions.dart';
import 'chat_agent_config.dart';
import 'openai_config.dart';
import 'project_type.dart';
import '../services/chat_agent_service.dart';

/// Configuration and initialization for the AI chat assistant
class ChatConfig {
  static bool _initialized = false;
  static ChatAgentService? _chatService;
  static ChatAgentConfig? _config;

  /// Initialize the chat assistant with OpenAI API key and project type
  static void initialize({
    required String apiKey,
    required ProjectType projectType,
    required ApiFunctionsService apiFunctionsService,
    ChatAgentConfig? config,
  }) {
    if (_initialized) return;

    // Set the OpenAI API key
    OpenAIConfig.setApiKey(apiKey);

    // Store config for future reference
    _config = config;

    // Create chat service with project type and API functions service
    _chatService = ChatAgentService(
      projectType: projectType,
      apiFunctionsService: apiFunctionsService,
      config: config,
    );

    _initialized = true;
  }

  /// Get the chat service instance
  static ChatAgentService getChatService() {
    if (!_initialized || _chatService == null) {
      throw Exception(
          'ChatConfig not initialized. Call ChatConfig.initialize() first.');
    }
    return _chatService!;
  }

  /// Get the current configuration
  static ChatAgentConfig? getConfig() => _config;

  /// Check if chat is initialized
  static bool get isInitialized => _initialized;

  /// Reset the configuration (useful for testing)
  static void reset() {
    _initialized = false;
    _chatService = null;
    _config = null;
  }
}
