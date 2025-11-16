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

  /// Stripe payment processor callback
  /// Takes the bill amount as a string and returns a map with:
  /// - 'success': bool indicating if payment succeeded
  /// - 'payment_id': String? the Stripe payment intent ID (if successful)
  /// - 'error': String? error message (if failed)
  final Future<Map<String, dynamic>> Function(String billAmount)?
      processStripePayment;

  ChatAgentConfig({
    this.getCurrentUser,
    this.customSystemPrompt,
    this.customWelcomeMessage,
    this.customChatTitle,
    this.processStripePayment,
  });
}
