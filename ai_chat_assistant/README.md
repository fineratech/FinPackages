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

### Simple Integration

The package exports a single `FloatingChatButton` widget that handles all configuration internally. Simply add it to your widget tree with all required configuration:

```dart
import 'package:ai_chat_assistant/ai_chat_assistant.dart';
import 'package:fin_api_functions/fin_api_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get your API functions service instance
    final apiFunctionsService = Get.find<ApiFunctionsService>();

    return Scaffold(
      appBar: AppBar(title: const Text('My App')),
      body: Stack(
        children: [
          // Your main content here
          Center(child: Text('Welcome to my app')),
          
          // Add the floating chat button
          FloatingChatButton(
            apiKey: 'your-openai-api-key-here',
            projectType: ProjectType.realEstate,
            apiFunctionsService: apiFunctionsService,
            // Optional customizations
            primaryColor: Colors.blue,
            secondaryColor: Colors.blueAccent,
            iconColor: Colors.white,
            bottom: 100,
            right: 20,
            backgroundColor: Colors.white,
            appBarColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
```

### Configuration Options

#### Required Parameters

- **`apiKey`** (String): Your OpenAI API key
- **`projectType`** (ProjectType): The type of project (e.g., `ProjectType.realEstate`)
- **`apiFunctionsService`** (ApiFunctionsService): Service for backend API operations

#### Optional Parameters

- **`config`** (ChatAgentConfig): Advanced configuration options:
  - `getCurrentUser`: Function to get current user information
  - `customSystemPrompt`: Override the default system prompt
  - `customWelcomeMessage`: Override the default welcome message
  - `customChatTitle`: Override the default chat title

- **Visual Customization**:
  - `primaryColor`: Primary color for the button gradient
  - `secondaryColor`: Secondary color for the button gradient
  - `iconColor`: Color of the chat icon
  - `bottom`: Bottom position of the button (default: 100)
  - `right`: Right position of the button (default: 20)
  - `backgroundColor`: Background color of the chat screen
  - `appBarColor`: App bar color of the chat screen

### Advanced Configuration Example

```dart
FloatingChatButton(
  apiKey: 'your-openai-api-key-here',
  projectType: ProjectType.realEstate,
  apiFunctionsService: apiFunctionsService,
  config: ChatAgentConfig(
    getCurrentUser: () async {
      // Return current user data
      return {
        'id': '123',
        'name': 'John Doe',
        'email': 'john@example.com',
      };
    },
    customSystemPrompt: 'You are a helpful assistant specialized in...',
    customWelcomeMessage: 'Welcome! How can I help you today?',
    customChatTitle: 'My Custom Chat',
  ),
  primaryColor: const Color(0xFF1976D2),
  secondaryColor: const Color(0xFF42A5F5),
  iconColor: Colors.white,
  bottom: 80,
  right: 16,
  backgroundColor: const Color(0xFFF5F5F5),
  appBarColor: const Color(0xFF1976D2),
);

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

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:ai_chat_assistant/ai_chat_assistant.dart';
import 'package:fin_api_functions/fin_api_functions.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize your API functions service
  Get.put(ApiFunctionsService(logger: Logger()));
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chat Demo',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final apiFunctionsService = Get.find<ApiFunctionsService>();
    
    return Scaffold(
      appBar: AppBar(title: const Text('My App')),
      body: Stack(
        children: [
          // Your app content
          const Center(child: Text('Hello World')),
          
          // AI Chat Assistant
          FloatingChatButton(
            apiKey: 'your-openai-api-key-here',
            projectType: ProjectType.realEstate,
            apiFunctionsService: apiFunctionsService,
          ),
        ],
      ),
    );
  }
}

## Architecture

The package is designed with a simple, self-contained architecture:

```
ai_chat_assistant/
├── lib/
│   ├── src/
│   │   ├── config/
│   │   │   ├── openai_config.dart       # OpenAI settings (internal)
│   │   │   ├── project_type.dart        # Project configurations (exported)
│   │   │   └── chat_agent_config.dart   # Chat config options (exported)
│   │   ├── models/
│   │   │   └── chat_message.dart        # Message data model (internal)
│   │   ├── services/
│   │   │   ├── chat_agent_service.dart  # Main service (internal)
│   │   │   ├── openai_service.dart      # OpenAI API integration (internal)
│   │   │   └── project_function_provider.dart  # Project functions (internal)
│   │   └── ui/
│   │       ├── chat_screen.dart         # Chat interface (internal)
│   │       └── floating_chat_button.dart # Main widget (exported)
│   └── ai_chat_assistant.dart           # Public API - exports only FloatingChatButton
└── pubspec.yaml
```

### Key Design Principles

1. **Single Entry Point**: The package exports only `FloatingChatButton` widget - all functionality is accessed through this single component
2. **Self-Contained**: All initialization and configuration happens within the widget - no separate initialization step required
3. **Type-Safe Configuration**: Uses strongly-typed enums and configuration objects
4. **Internal Implementation**: All services, models, and internal screens are kept private to the package

## License

This package is private and not published to pub.dev.
