# Changelog

## 2.0.0 - 2025-10-05

### BREAKING CHANGES
- **Simplified API**: Package now exports only `FloatingChatButton` widget with all configuration passed directly to it
- **Removed Exports**: `ChatConfig`, `ChatAgentService`, `OpenAIService`, `ChatScreen`, and other internal classes are no longer exported
- **Self-Contained Widget**: `FloatingChatButton` now handles all initialization internally - no separate `ChatConfig.initialize()` call needed

### Migration Guide

**Before (v1.x):**
```dart
// Initialization
ChatConfig.initialize(
  apiKey: 'key',
  projectType: ProjectType.realEstate,
  apiFunctionsService: service,
);

// Usage
FloatingChatButton(
  chatService: ChatConfig.getChatService(),
  primaryColor: Colors.blue,
)
```

**After (v2.x):**
```dart
// Direct usage - no initialization needed
FloatingChatButton(
  apiKey: 'key',
  projectType: ProjectType.realEstate,
  apiFunctionsService: service,
  primaryColor: Colors.blue,
)
```

### Changes
- `FloatingChatButton` now accepts `apiKey`, `projectType`, and `apiFunctionsService` as required parameters
- All configuration is passed directly to the widget
- Internal services and screens are now private to the package
- Updated exports to only include `FloatingChatButton`, `ProjectType`, and `ChatAgentConfig`

## 1.0.0 - 2025-01-XX

### Initial Release
- AI-powered chat assistant with OpenAI integration
- Project-based configuration system (Real Estate, etc.)
- Integrated ChatConfig for easy initialization
- Customizable UI components (FloatingChatButton, ChatScreen)
- Function calling support with `fin_api_functions`
- Support for user context through ChatAgentConfig
- Project-specific prompts, welcome messages, and chat titles

### Features
- **Project Types**: Enum-based project configuration
- **ChatConfig**: Built-in configuration management
- **Function Provider**: Automatic function calling for Real Estate operations
- **User Context**: Configurable getCurrentUser callback
- **Customization**: Full theme customization support
- **API Integration**: Seamless integration with fin_api_functions package
