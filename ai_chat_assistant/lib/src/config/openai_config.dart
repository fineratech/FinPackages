/// Configuration for OpenAI service
class OpenAIConfig {
  // Model configurations
  static const String defaultModel = 'gpt-4o-mini';
  static const String fallbackModel = 'gpt-3.5-turbo';

  // Request configurations
  static const int maxTokens = 800;
  static const double temperature = 0.7;
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);

  // Function calling settings
  static const bool enableFunctionCalling = true;
  static const int maxChatHistoryLength = 10;

  /// Private API key - should be set by the app
  static String? _apiKey;

  /// Set the API key
  static void setApiKey(String key) {
    _apiKey = key;
  }

  /// Get the API key
  static String getApiKey() {
    if (_apiKey == null || _apiKey!.isEmpty) {
      throw Exception('OpenAI API key is not configured. Please call OpenAIConfig.setApiKey() first.');
    }
    return _apiKey!;
  }

  /// Check if API key is configured
  static bool get isConfigured => _apiKey != null && _apiKey!.isNotEmpty;
}
