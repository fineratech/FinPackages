/// Configuration options for the chat agent
class ChatAgentConfig {
  /// Current user information provider
  final Future<Map<String, dynamic>?> Function()? getCurrentUser;

  /// Custom system prompt override
  final String? customSystemPrompt;

  /// Custom welcome message override
  final String? customWelcomeMessage;

  /// Custom chat title override
  final String? customChatTitle;

  ChatAgentConfig({
    this.getCurrentUser,
    this.customSystemPrompt,
    this.customWelcomeMessage,
    this.customChatTitle,
  });
}
