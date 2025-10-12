import 'package:flutter/material.dart';
import 'package:ai_chat_assistant/ai_chat_assistant.dart';
import 'package:fin_api_functions/fin_api_functions.dart';

/// Example demonstrating the simplified FloatingChatButton usage
class ChatButtonExample extends StatelessWidget {
  final ApiFunctionsService apiFunctionsService;

  const ChatButtonExample({
    super.key,
    required this.apiFunctionsService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat Assistant Example'),
      ),
      body: Stack(
        children: [
          // Your main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to the App!',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Click the floating button to start chatting',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),

          // AI Chat Assistant - All configuration in one place!
          FloatingChatButton(
            // Required: OpenAI API key
            apiKey: const String.fromEnvironment(
              'OPENAI_API_KEY',
              defaultValue: 'your-api-key-here',
            ),

            // Required: Project type for context
            projectType: ProjectType.realEstate,

            // Required: API functions service
            apiFunctionsService: apiFunctionsService,

            // Optional: Advanced configuration
            config: ChatAgentConfig(
              getCurrentUser: () async {
                // Return current user data
                return {
                  'id': '123',
                  'name': 'John Doe',
                  'email': 'john@example.com',
                  'role': 'property_manager',
                };
              },
              customSystemPrompt: 'You are a helpful real estate assistant.',
              customWelcomeMessage: 'Hello! How can I help you today?',
              customChatTitle: 'Real Estate Assistant',
            ),

            // Optional: Visual customization
            primaryColor: const Color(0xFF1976D2),
            secondaryColor: const Color(0xFF42A5F5),
            iconColor: Colors.white,

            backgroundColor: Colors.white,
            appBarColor: const Color(0xFF1976D2),
          ),
        ],
      ),
    );
  }
}

/// Minimal example with only required parameters
class MinimalChatButtonExample extends StatelessWidget {
  final ApiFunctionsService apiFunctionsService;

  const MinimalChatButtonExample({
    super.key,
    required this.apiFunctionsService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Center(child: Text('Minimal Example')),

          // Minimal configuration - uses all defaults
          FloatingChatButton(
            apiKey: 'your-openai-api-key',
            projectType: ProjectType.realEstate,
            apiFunctionsService: apiFunctionsService,
          ),
        ],
      ),
    );
  }
}

/// Example with custom styling
class StyledChatButtonExample extends StatelessWidget {
  final ApiFunctionsService apiFunctionsService;

  const StyledChatButtonExample({
    super.key,
    required this.apiFunctionsService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Center(child: Text('Custom Styled Example')),

          // Custom styling example
          FloatingChatButton(
            apiKey: 'your-openai-api-key',
            projectType: ProjectType.realEstate,
            apiFunctionsService: apiFunctionsService,

            // Custom colors matching your app theme
            primaryColor: Colors.purple,
            secondaryColor: Colors.purpleAccent,
            iconColor: Colors.white,
            backgroundColor: const Color(0xFFF5F5F5),
            appBarColor: Colors.purple,
          ),
        ],
      ),
    );
  }
}
