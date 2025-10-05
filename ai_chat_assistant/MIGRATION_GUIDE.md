# Migration Guide: v1.x to v2.0

## Overview

Version 2.0 simplifies the API by exporting only the `FloatingChatButton` widget. All configuration is now passed directly to the widget, eliminating the need for separate initialization steps.

## What Changed

### Removed from Public API
- `ChatConfig` class
- `ChatAgentService` class
- `OpenAIService` class
- `ChatScreen` widget
- `ProjectFunctionProvider` class
- `OpenAIConfig` class
- `ChatMessage` model

### Still Available
- `FloatingChatButton` widget (now with enhanced parameters)
- `ProjectType` enum
- `ChatAgentConfig` class

## Migration Steps

### Step 1: Remove Initialization Code

**Before:**
```dart
// In main.dart or app initialization
ChatConfig.initialize(
  apiKey: 'your-openai-api-key',
  projectType: ProjectType.realEstate,
  apiFunctionsService: apiFunctionsService,
  config: ChatAgentConfig(...),
);
```

**After:**
```dart
// No initialization needed!
// Configuration is passed directly to the widget
```

### Step 2: Update FloatingChatButton Usage

**Before:**
```dart
FloatingChatButton(
  chatService: ChatConfig.getChatService(),
  primaryColor: Colors.blue,
  secondaryColor: Colors.blueAccent,
  iconColor: Colors.white,
  bottom: 100,
  right: 20,
  backgroundColor: Colors.white,
  appBarColor: Colors.blue,
)
```

**After:**
```dart
FloatingChatButton(
  // Required parameters
  apiKey: 'your-openai-api-key',
  projectType: ProjectType.realEstate,
  apiFunctionsService: apiFunctionsService,
  
  // Optional configuration
  config: ChatAgentConfig(
    getCurrentUser: () async => {...},
    customSystemPrompt: '...',
    customWelcomeMessage: '...',
    customChatTitle: '...',
  ),
  
  // Visual customization (same as before)
  primaryColor: Colors.blue,
  secondaryColor: Colors.blueAccent,
  iconColor: Colors.white,
  bottom: 100,
  right: 20,
  backgroundColor: Colors.white,
  appBarColor: Colors.blue,
)
```

### Step 3: Remove Wrapper Widgets (if any)

If you created wrapper widgets that used `ChatConfig.getChatService()`, you can simplify them:

**Before:**
```dart
class AppChatButton extends StatelessWidget {
  const AppChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingChatButton(
      chatService: ChatConfig.getChatService(),
      primaryColor: AppColors.primary,
      // other properties...
    );
  }
}
```

**After:**
```dart
class AppChatButton extends StatelessWidget {
  const AppChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    final apiFunctionsService = Get.find<ApiFunctionsService>();
    
    return FloatingChatButton(
      apiKey: AppConfig.openAiApiKey,
      projectType: ProjectType.realEstate,
      apiFunctionsService: apiFunctionsService,
      primaryColor: AppColors.primary,
      // other properties...
    );
  }
}
```

## Benefits of v2.0

1. **Simpler API**: One widget, all configuration in one place
2. **No Global State**: Each widget instance has its own configuration
3. **Better Encapsulation**: Internal implementation details are hidden
4. **Easier Testing**: No need to manage global initialization state
5. **More Flexible**: Can have multiple chat buttons with different configurations

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:ai_chat_assistant/ai_chat_assistant.dart';
import 'package:fin_api_functions/fin_api_functions.dart';
import 'package:get/get.dart';

void main() {
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
          const Center(child: Text('Welcome!')),
          
          // AI Chat Assistant - all configuration in one place
          FloatingChatButton(
            apiKey: const String.fromEnvironment('OPENAI_API_KEY'),
            projectType: ProjectType.realEstate,
            apiFunctionsService: apiFunctionsService,
            config: ChatAgentConfig(
              getCurrentUser: () async {
                return {
                  'id': '123',
                  'name': 'John Doe',
                  'email': 'john@example.com',
                };
              },
            ),
            primaryColor: const Color(0xFF1976D2),
            secondaryColor: const Color(0xFF42A5F5),
          ),
        ],
      ),
    );
  }
}
```

## Need Help?

If you encounter any issues during migration, please check:
1. Ensure all required parameters (`apiKey`, `projectType`, `apiFunctionsService`) are provided
2. Remove any references to `ChatConfig.initialize()`
3. Remove any imports that reference internal classes like `ChatAgentService` or `OpenAIService`
4. Update your wrapper widgets to pass configuration directly to `FloatingChatButton`
