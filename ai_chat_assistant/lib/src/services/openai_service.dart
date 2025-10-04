import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../config/openai_config.dart';
import '../models/chat_message.dart';

/// Function definitions interface for OpenAI function calling
abstract class FunctionDefinitionsProvider {
  List<Map<String, dynamic>> getFunctionDefinitions();
  Future<Map<String, dynamic>> executeFunction(
    String functionName,
    Map<String, dynamic> args,
  );
}

class OpenAIService {
  final Dio _dio = Dio();
  final String _apiKey;
  final FunctionDefinitionsProvider? _functionProvider;
  static const String _openAIApiUrl =
      'https://api.openai.com/v1/chat/completions';
  static const String openAIModel = OpenAIConfig.defaultModel;
  final String _systemPrompt;

  OpenAIService({
    required String apiKey,
    FunctionDefinitionsProvider? functionProvider,
    String? systemPrompt,
  })  : _apiKey = apiKey,
        _functionProvider = functionProvider,
        _systemPrompt = systemPrompt ??
            '''You are a helpful AI assistant. You can help users with various tasks and answer their questions.

Always be polite, professional, and provide accurate information.''' {
    _dio.options.headers = {
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
    };
    _dio.options.connectTimeout = OpenAIConfig.connectTimeout;
    _dio.options.receiveTimeout = OpenAIConfig.receiveTimeout;
  }

  /// Send a message to OpenAI with function calling support
  Future<String> sendMessage(
    String message,
    List<ChatMessage> chatHistory,
  ) async {
    try {
      // Build messages array for OpenAI
      final List<Map<String, dynamic>> messages = [
        {"role": "system", "content": _systemPrompt}
      ];

      // Add chat history (limit to last N messages to manage token usage)
      final recentHistory = chatHistory.length > OpenAIConfig.maxChatHistoryLength
          ? chatHistory.sublist(chatHistory.length - OpenAIConfig.maxChatHistoryLength)
          : chatHistory;

      for (final msg in recentHistory) {
        messages.add({
          "role": msg.isUser ? "user" : "assistant",
          "content": msg.content
        });
      }

      // Add current message
      messages.add({"role": "user", "content": message});

      final requestData = {
        "model": openAIModel,
        "messages": messages,
        "temperature": OpenAIConfig.temperature,
        "max_tokens": OpenAIConfig.maxTokens
      };

      // Add function definitions if provider is available
      if (_functionProvider != null && OpenAIConfig.enableFunctionCalling) {
        requestData["functions"] = _functionProvider!.getFunctionDefinitions();
        requestData["function_call"] = "auto";
      }

      final response = await _dio.post(
        _openAIApiUrl,
        data: requestData,
      );

      if (response.statusCode != 200) {
        throw Exception('OpenAI API error: ${response.statusCode}');
      }

      final responseData = response.data;
      final choice = responseData['choices'][0];
      Logger().i(
          'OpenAI response status: ${response.statusCode}, summary: ${responseData['choices']?[0]?['message']?.keys?.toList()}');
      Logger().i('OpenAI response: $responseData');

      // Check if OpenAI wants to call a function
      if (choice['message']['function_call'] != null &&
          _functionProvider != null) {
        return await _handleFunctionCall(
          choice['message']['function_call'],
          messages,
        );
      }

      return choice['message']['content'] ??
          'I apologize, but I couldn\'t generate a response. Please try again.';
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return 'Connection timed out. Please check your internet connection and try again.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        return 'Request timed out. Please try again.';
      } else if (e.response?.statusCode == 401) {
        return 'Authentication failed. Please check the API key configuration.';
      } else if (e.response?.statusCode == 429) {
        return 'Rate limit exceeded. Please wait a moment and try again.';
      } else {
        return 'Network error occurred. Please try again later.';
      }
    } catch (e) {
      return 'An unexpected error occurred. Please try again later.';
    }
  }

  /// Handle function calling and get the final response
  Future<String> _handleFunctionCall(
    Map<String, dynamic> functionCall,
    List<Map<String, dynamic>> messages,
  ) async {
    final functionName = functionCall['name'];
    final functionArgs = jsonDecode(functionCall['arguments'] ?? '{}');

    try {
      // Execute the function and get result
      final functionResult = await _functionProvider!.executeFunction(
        functionName,
        functionArgs,
      );

      Logger().i("Function Response OpenAI: ${functionResult.toString()}");

      // Add function call to messages
      messages.add({
        "role": "assistant",
        "content": null,
        "function_call": functionCall
      });

      // Add function result to messages
      messages.add({
        "role": "function",
        "name": functionName,
        "content": jsonEncode(functionResult)
      });

      // Get final response from OpenAI
      final finalRequestData = {
        "model": openAIModel,
        "messages": messages,
        "functions": _functionProvider!.getFunctionDefinitions(),
        "function_call": "auto",
        "temperature": OpenAIConfig.temperature,
        "max_tokens": OpenAIConfig.maxTokens
      };

      Logger().i("Calling completion API again");

      final finalResponse =
          await _dio.post(_openAIApiUrl, data: finalRequestData);

      Logger().i("Final Response OpenAI: ${finalResponse.toString()}");

      if (finalResponse.statusCode != 200) {
        throw Exception(
            'OpenAI API error in final response: ${finalResponse.statusCode}');
      }

      final finalChoice = finalResponse.data['choices'][0];

      // Check if OpenAI wants to make another function call
      if (finalChoice['message']['function_call'] != null) {
        Logger().i("OpenAI is making another function call");
        return await _handleFunctionCall(
          finalChoice['message']['function_call'],
          messages,
        );
      }

      return finalChoice['message']['content'] ??
          'I retrieved the information but couldn\'t format a response. Please try again.';
    } catch (e) {
      Logger().i("Error OpenAI: ${e.toString()}");
      return 'I encountered an error while processing your request: ${_getErrorMessage(e)}';
    }
  }

  /// Get error message from exception
  String _getErrorMessage(dynamic error) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return 'An unexpected error occurred';
  }

  /// Test the OpenAI API connection
  Future<bool> testConnection() async {
    try {
      final response = await _dio.post(
        _openAIApiUrl,
        data: {
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "user", "content": "Test"}
          ],
          "max_tokens": 5
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
