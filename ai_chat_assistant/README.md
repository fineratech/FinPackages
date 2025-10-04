# AI Chat Assistant

A Flutter package for AI-powered chat functionality with OpenAI integration and project-specific configurations.

## Features

- Beautiful, animated chat UI with floating chat button
- OpenAI GPT integration with function calling support
- Project-based configuration (Real Estate, etc.)
- Automatic function definitions from `fin_api_functions`
- Customizable colors and styling
- Easy integration with existing Flutter apps

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  ai_chat_assistant:
    path: packages/ai_chat_assistant
```

## Usage

### 1. Initialize with API Key and Project Type

In your main app initialization, configure the chat assistant with your OpenAI API key and project type:

```dart
import 'package:ai_chat_assistant/ai_chat_assistant.dart';
import 'package:fin_api_functions/fin_api_functions.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize ApiFunctionsService first
  Get.put(ApiFunctionsService(logger: Logger()));

  // Initialize AI Chat Assistant with project type
  ChatConfig.initialize(
    apiKey: 'your-openai-api-key-here',
    projectType: ProjectType.realEstate,
  );

  runApp(MyApp());
}
```

### 2. Create a Chat Config Helper

Create a configuration helper in your app:

```dart
import 'package:ai_chat_assistant/ai_chat_assistant.dart';
import 'package:fin_api_functions/fin_api_functions.dart';
import 'package:get/get.dart';

class ChatConfig {
  static bool _initialized = false;
  static ChatAgentService? _chatService;

  static void initialize({
    required String apiKey,
    required ProjectType projectType,
  }) {
    if (_initialized) return;

    OpenAIConfig.setApiKey(apiKey);
    final apiFunctionsService = Get.find<ApiFunctionsService>();

    _chatService = ChatAgentService(
      projectType: projectType,
      apiFunctionsService: apiFunctionsService,
    );

    _initialized = true;
  }

  static ChatAgentService getChatService() {
    if (!_initialized || _chatService == null) {
      throw Exception('ChatConfig not initialized');
    }
    return _chatService!;
  }
}
```

### 3. Add the Floating Chat Button

Create a wrapper widget for the floating chat button:

```dart
import 'package:ai_chat_assistant/ai_chat_assistant.dart';

class AppFloatingChatButton extends StatelessWidget {
  const AppFloatingChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingChatButton(
      chatService: ChatConfig.getChatService(),
      primaryColor: Colors.black,
      secondaryColor: Colors.grey,
      iconColor: Colors.white,
      backgroundColor: Colors.white,
      appBarColor: Colors.white,
      bottom: 100,
      right: 20,
    );
  }
}
```

Use it in your screens:

```dart
Stack(
  children: [
    // Your existing content
    const AppFloatingChatButton(),
  ],
)
```

## Project Types

The package supports different project types with pre-configured prompts and functions:

- `ProjectType.realEstate` - Real Estate Management
  - Get total outstanding balance
  - View all properties
  - Get current user info
  - Check user's balance

Each project type automatically configures:
- System prompt tailored to the domain
- Welcome message
- Chat title
- Function definitions from `fin_api_functions`

## Customization

### Chat Screen Colors

```dart
ChatScreen(
  chatService: ChatConfig.getChatService(),
  backgroundColor: Colors.grey[100],
  appBarColor: Colors.white,
  primaryColor: Colors.black,
  secondaryColor: Colors.grey,
  onlineStatus: 'Online',
)
```

### Adding New Project Types

To add a new project type:

1. Add to the `ProjectType` enum in `project_type.dart`
2. Add cases to the extension methods for:
   - `systemPrompt`
   - `welcomeMessage`
   - `chatTitle`
3. Add function definitions in `ProjectFunctionProvider`

## Architecture

```
ai_chat_assistant/
├── lib/
│   ├── src/
│   │   ├── config/
│   │   │   ├── openai_config.dart       # OpenAI settings
│   │   │   └── project_type.dart        # Project configurations
│   │   ├── models/
│   │   │   └── chat_message.dart        # Message data model
│   │   ├── services/
│   │   │   ├── chat_agent_service.dart  # Main service
│   │   │   ├── openai_service.dart      # OpenAI API integration
│   │   │   └── project_function_provider.dart  # Project functions
│   │   └── ui/
│   │       ├── chat_screen.dart         # Chat interface
│   │       └── floating_chat_button.dart # FAB widget
│   └── ai_chat_assistant.dart           # Public exports
└── pubspec.yaml
```

## License

This package is private and not published to pub.dev.
