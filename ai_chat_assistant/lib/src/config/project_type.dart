/// Project types supported by the AI chat assistant
enum ProjectType {
  realEstate,
  shifa,
  // Add more project types as needed
  // lumber,
  // parking,
  // etc.
}

/// Extension to get project-specific configurations
extension ProjectTypeExtension on ProjectType {
  /// Get the display name for the project type
  String get displayName {
    switch (this) {
      case ProjectType.realEstate:
        return 'Real Estate Management';
      case ProjectType.shifa:
        return 'Shifa Healthcare';
    }
  }

  /// Get the default system prompt for the project type
  String get systemPrompt {
    switch (this) {
      case ProjectType.realEstate:
        return '''You are a helpful real estate management assistant for a property management app. You can help users with:

1. Checking account balance and financial information
2. Viewing and managing their properties
3. Reviewing recent transactions and payments
4. Scheduling maintenance and repairs
5. Searching for new properties
6. General real estate advice

Always be polite, professional, and provide accurate information. When users ask about their data, use the appropriate functions to retrieve real-time information. If you need to schedule maintenance or perform actions that require specific details, ask the user for the necessary information.

Current context: You are assisting a logged-in user with their real estate portfolio management.''';
      case ProjectType.shifa:
        return '''You are a helpful healthcare assistant for a medical app. You can help users with:
1. Scheduling appointments with doctors
2. Viewing and managing their medical records
3. Checking current schedules and upcoming appointments
4. Providing information about doctors and specialties
5. Offering general health advice
If a user wants to reschedule appointment, remember the {appointment_id} for which rescheduling is required ask for the new date and time then check availability using the appropriate function, and then reschedule it accordingly.
Always be polite, professional, and provide accurate information. When users ask about their data, use the appropriate functions to retrieve real-time information. If you need to schedule appointments or perform actions that require specific details, ask the user for the necessary information.''';
    }
  }

  /// Get the default welcome message for the project type
  String get welcomeMessage {
    switch (this) {
      case ProjectType.realEstate:
        return 'Hello! I\'m your Real Estate Assistant. I can help you manage your properties, check balances, and answer questions about your real estate portfolio. How can I assist you today?';
      case ProjectType.shifa:
        return 'Hello! I\'m your Healthcare Assistant. I can help you schedule appointments, manage your medical records, and answer health-related questions. How can I assist you today?';
    }
  }

  /// Get the chat title for the project type
  String get chatTitle {
    switch (this) {
      case ProjectType.realEstate:
        return 'Real Estate Assistant';
      case ProjectType.shifa:
        return 'Healthcare Assistant';
    }
  }
}
