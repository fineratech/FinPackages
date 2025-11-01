import 'package:logger/logger.dart';
import 'package:fin_api_functions/fin_api_functions.dart';
import 'openai_service.dart';
import 'project_function_provider.dart';
import '../config/openai_config.dart';
import '../config/project_type.dart';
import '../config/chat_agent_config.dart';
import '../models/chat_message.dart';

class ChatAgentService {
  static final Logger _logger = Logger();
  late final OpenAIService _openAIService;
  late final ProjectFunctionProvider _functionProvider;
  late final String _systemPrompt;
  final ProjectType projectType;
  final ChatAgentConfig? config;

  ChatAgentService({
    required this.projectType,
    required ApiFunctionsService apiFunctionsService,
    this.config,
  }) {
    if (!OpenAIConfig.isConfigured) {
      throw Exception(
          'OpenAI API key is not configured. Please call OpenAIConfig.setApiKey() first.');
    }

    // Create project-specific function provider
    _functionProvider = ProjectFunctionProvider(
      projectType: projectType,
      apiFunctionsService: apiFunctionsService,
      config: config,
    );

    // Use custom system prompt or project-specific default
    _systemPrompt = config?.customSystemPrompt ?? projectType.systemPrompt;

    _openAIService = OpenAIService(
      apiKey: OpenAIConfig.getApiKey(),
      functionProvider: _functionProvider,
      systemPrompt: _systemPrompt,
    );
  }

  /// Get the function provider for this service
  ProjectFunctionProvider get functionProvider => _functionProvider;

  /// Get the system prompt for this service
  String get systemPrompt => _systemPrompt;

  /// Send a message to the chat agent and get a response
  Future<String> sendMessage(
      String message, List<ChatMessage> chatHistory) async {
    try {
      return await _openAIService.sendMessage(message, chatHistory);
    } catch (e) {
      // Log error for debugging
      _logger.i('ChatAgentService error', error: e);
      return 'I apologize, but I\'m experiencing technical difficulties. Please try again in a moment.';
    }
  }

  /// Test if the service is properly configured and connected
  Future<bool> testConnection() async {
    try {
      return await _openAIService.testConnection();
    } catch (e) {
      return false;
    }
  }

  /// Check if the service is properly configured
  bool get isConfigured => OpenAIConfig.isConfigured;

  /// Get the welcome message for the project type
  String get welcomeMessage => config?.customWelcomeMessage ?? projectType.welcomeMessage;

  /// Get the chat title for the project type
  String get chatTitle => config?.customChatTitle ?? projectType.chatTitle;
}
