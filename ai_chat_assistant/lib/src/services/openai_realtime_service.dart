import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:logger/logger.dart';
import 'realtime_function_provider.dart';

/// Service for managing OpenAI Realtime API WebSocket connection
///
/// Uses the latest GA model: gpt-realtime
/// Documentation: https://platform.openai.com/docs/guides/realtime
///
/// Pricing (as of 2025):
/// - Audio Input: $0.032 per 1M tokens ($0.0004 cached)
/// - Audio Output: $0.064 per 1M tokens
class OpenAIRealtimeService {
  final String apiKey;
  final RealtimeFunctionProvider functionProvider;
  final String systemPrompt;
  final Logger _logger = Logger();

  WebSocketChannel? _channel;
  bool _isConnected = false;
  String? _sessionId;

  // Stream controllers for events
  final _connectionController = StreamController<bool>.broadcast();
  final _transcriptController = StreamController<String>.broadcast();
  final _audioController = StreamController<Uint8List>.broadcast();
  final _errorController = StreamController<String>.broadcast();
  final _statusController = StreamController<String>.broadcast();
  final _functionCallController =
      StreamController<Map<String, dynamic>>.broadcast();

  // Buffers for function call arguments
  final Map<String, StringBuffer> _functionCallBuffers = {};

  Stream<bool> get connectionStream => _connectionController.stream;
  Stream<String> get transcriptStream => _transcriptController.stream;
  Stream<Uint8List> get audioStream => _audioController.stream;
  Stream<String> get errorStream => _errorController.stream;
  Stream<String> get statusStream => _statusController.stream;
  Stream<Map<String, dynamic>> get functionCallStream =>
      _functionCallController.stream;

  bool get isConnected => _isConnected;

  OpenAIRealtimeService({
    required this.apiKey,
    required this.functionProvider,
    required this.systemPrompt,
  });

  /// Connect to OpenAI Realtime API
  Future<void> connect() async {
    try {
      _statusController.add('Connecting to OpenAI Realtime API...');
      _logger.i('Connecting to OpenAI Realtime API');

      // Use the latest GA model: gpt-realtime
      // OpenAI released gpt-realtime as the production model (replaces preview version)
      final uri = Uri.parse(
        'wss://api.openai.com/v1/realtime?model=gpt-realtime',
      );

      // Create WebSocket connection with API key via Sec-WebSocket-Protocol header
      // This is the official authentication method for WebSocket connections
      _channel = WebSocketChannel.connect(
        uri,
        protocols: [
          'realtime',
          'openai-insecure-api-key.$apiKey',
          'openai-beta.realtime-v1',
        ],
      );

      // Wait a moment for connection to establish
      await Future.delayed(const Duration(milliseconds: 200));

      // Send session configuration
      _channel!.sink.add(jsonEncode({
        'type': 'session.update',
        'session': {
          'modalities': ['text', 'audio'],
          'instructions': systemPrompt,
          'voice': 'alloy',
          'input_audio_format': 'pcm16',
          'output_audio_format': 'pcm16',
          'input_audio_transcription': {
            'model': 'whisper-1',
          },
          'turn_detection': {
            'type': 'server_vad',
            'threshold': 0.5,
            'prefix_padding_ms': 300,
            'silence_duration_ms': 500,
          },
          'tools': functionProvider.getFunctionDefinitions(),
          'tool_choice': 'auto',
          'temperature': 0.8,
        },
      }));

      // Listen to messages
      _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnection,
      );

      _isConnected = true;
      _connectionController.add(true);
      _statusController.add('Connected! Start speaking...');
      _logger.i('Connected to OpenAI Realtime API');
    } catch (e) {
      _logger.e('Failed to connect to OpenAI Realtime API', error: e);
      _errorController.add('Failed to connect: $e');
      _statusController.add('Connection failed');
      _isConnected = false;
      _connectionController.add(false);
    }
  }


  /// Handle incoming WebSocket messages
  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message as String);
      final eventType = data['type'] as String?;

      _logger.d('Received event: $eventType');

      switch (eventType) {
        case 'session.created':
          _handleSessionCreated(data);
          break;
        case 'session.updated':
          _handleSessionUpdated(data);
          break;
        case 'conversation.item.created':
          _handleConversationItemCreated(data);
          break;
        case 'input_audio_buffer.speech_started':
          _statusController.add('Listening...');
          break;
        case 'input_audio_buffer.speech_stopped':
          _statusController.add('Processing...');
          break;
        case 'input_audio_buffer.committed':
          _logger.i('Audio buffer committed');
          break;
        case 'conversation.item.input_audio_transcription.completed':
          _handleInputTranscription(data);
          break;
        case 'response.created':
          _statusController.add('AI is responding...');
          break;
        case 'response.done':
          _statusController.add('Ready');
          break;
        case 'response.audio.delta':
          _handleAudioDelta(data);
          break;
        case 'response.audio.done':
          _logger.i('Audio response completed');
          break;
        case 'response.audio_transcript.delta':
          _handleAudioTranscriptDelta(data);
          break;
        case 'response.audio_transcript.done':
          _logger.i('Audio transcript completed');
          break;
        case 'response.text.delta':
          _handleTextDelta(data);
          break;
        case 'response.text.done':
          _logger.i('Text response completed');
          break;
        case 'response.function_call_arguments.delta':
          _handleFunctionCallArgumentsDelta(data);
          break;
        case 'response.function_call_arguments.done':
          _handleFunctionCallArgumentsDone(data);
          break;
        case 'response.output_item.done':
          _handleOutputItemDone(data);
          break;
        case 'error':
          _handleApiError(data);
          break;
        default:
          _logger.d('Unhandled event type: $eventType');
      }
    } catch (e) {
      _logger.e('Error handling message', error: e);
      _errorController.add('Error processing message: $e');
    }
  }

  /// Handle session created event
  void _handleSessionCreated(Map<String, dynamic> data) {
    _sessionId = data['session']?['id'] as String?;
    _logger.i('Session created: $_sessionId');
    _statusController.add('Session established');
  }

  /// Handle session updated event
  void _handleSessionUpdated(Map<String, dynamic> data) {
    _logger.i('Session updated successfully');
  }

  /// Handle conversation item created
  void _handleConversationItemCreated(Map<String, dynamic> data) {
    _logger.d('Conversation item created: ${data['item']?['id']}');
  }

  /// Handle input audio transcription
  void _handleInputTranscription(Map<String, dynamic> data) {
    final transcript = data['transcript'] as String?;
    if (transcript != null && transcript.isNotEmpty) {
      _logger.i('User said: $transcript');
      _transcriptController.add('You: $transcript');
    }
  }

  /// Handle audio delta (streaming audio response)
  void _handleAudioDelta(Map<String, dynamic> data) {
    try {
      final base64Audio = data['delta'] as String?;
      if (base64Audio != null && base64Audio.isNotEmpty) {
        final audioBytes = base64Decode(base64Audio);
        _audioController.add(Uint8List.fromList(audioBytes));
      }
    } catch (e) {
      _logger.e('Error decoding audio delta', error: e);
    }
  }

  /// Handle audio transcript delta
  void _handleAudioTranscriptDelta(Map<String, dynamic> data) {
    final delta = data['delta'] as String?;
    if (delta != null && delta.isNotEmpty) {
      // This is streaming, so we could buffer it if needed
      _logger.d('Audio transcript delta: $delta');
    }
  }

  /// Handle text delta
  void _handleTextDelta(Map<String, dynamic> data) {
    final delta = data['delta'] as String?;
    if (delta != null && delta.isNotEmpty) {
      _transcriptController.add('AI: $delta');
    }
  }

  /// Handle function call arguments delta
  void _handleFunctionCallArgumentsDelta(Map<String, dynamic> data) {
    final callId = data['call_id'] as String?;
    final delta = data['delta'] as String?;

    if (callId != null && delta != null) {
      _functionCallBuffers.putIfAbsent(callId, () => StringBuffer());
      _functionCallBuffers[callId]!.write(delta);
      _logger.d('Function call arguments delta for $callId');
    }
  }

  /// Handle function call arguments done
  void _handleFunctionCallArgumentsDone(Map<String, dynamic> data) async {
    final callId = data['call_id'] as String?;
    final arguments = data['arguments'] as String?;
    final itemId = data['item_id'] as String?;

    if (callId != null && itemId != null) {
      // Use the accumulated arguments or the final arguments
      final finalArguments =
          arguments ?? _functionCallBuffers[callId]?.toString() ?? '{}';

      _logger.i('Function call arguments done: $callId');
      _logger.d('Arguments: $finalArguments');

      // Clean up buffer
      _functionCallBuffers.remove(callId);

      // Parse and execute the function
      try {
        final argsJson = jsonDecode(finalArguments) as Map<String, dynamic>;
        final functionName = data['name'] as String?;

        if (functionName != null) {
          _statusController.add('Executing: $functionName');
          _functionCallController.add({
            'name': functionName,
            'arguments': argsJson,
            'call_id': callId,
            'item_id': itemId,
          });

          // Execute the function
          final result = await functionProvider.executeFunction(
            functionName,
            argsJson,
          );

          // Send the result back to the API
          _sendFunctionCallOutput(callId, result);
        }
      } catch (e) {
        _logger.e('Error executing function', error: e);
        _sendFunctionCallOutput(callId, {
          'error': 'Failed to execute function: $e',
        });
      }
    }
  }

  /// Handle output item done
  void _handleOutputItemDone(Map<String, dynamic> data) {
    final item = data['item'];
    if (item != null) {
      final type = item['type'] as String?;
      if (type == 'function_call') {
        _logger.i('Function call item completed: ${item['id']}');
      }
    }
  }

  /// Handle API errors
  void _handleApiError(Map<String, dynamic> data) {
    final error = data['error'];
    final message = error?['message'] ?? 'Unknown error occurred';
    _logger.e('API Error: $message');
    _errorController.add(message);
    _statusController.add('Error: $message');
  }

  /// Handle WebSocket errors
  void _handleError(dynamic error) {
    _logger.e('WebSocket error', error: error);
    _errorController.add('Connection error: $error');
    _statusController.add('Connection error');
    _isConnected = false;
    _connectionController.add(false);
  }

  /// Handle WebSocket disconnection
  void _handleDisconnection() {
    _logger.i('Disconnected from OpenAI Realtime API');
    _statusController.add('Disconnected');
    _isConnected = false;
    _connectionController.add(false);
  }

  /// Send audio buffer data
  void sendAudioData(Uint8List audioData) {
    if (!_isConnected) {
      _logger.w('Cannot send audio: Not connected');
      return;
    }

    try {
      final base64Audio = base64Encode(audioData);
      final event = jsonEncode({
        'type': 'input_audio_buffer.append',
        'audio': base64Audio,
      });
      _channel?.sink.add(event);
    } catch (e) {
      _logger.e('Error sending audio data', error: e);
    }
  }

  /// Commit the audio buffer
  void commitAudioBuffer() {
    if (!_isConnected) return;

    try {
      final event = jsonEncode({
        'type': 'input_audio_buffer.commit',
      });
      _channel?.sink.add(event);
      _logger.i('Audio buffer committed');
    } catch (e) {
      _logger.e('Error committing audio buffer', error: e);
    }
  }

  /// Clear the audio buffer
  void clearAudioBuffer() {
    if (!_isConnected) return;

    try {
      final event = jsonEncode({
        'type': 'input_audio_buffer.clear',
      });
      _channel?.sink.add(event);
      _logger.i('Audio buffer cleared');
    } catch (e) {
      _logger.e('Error clearing audio buffer', error: e);
    }
  }

  /// Send function call output
  void _sendFunctionCallOutput(String callId, Map<String, dynamic> output) {
    if (!_isConnected) return;

    try {
      final event = jsonEncode({
        'type': 'conversation.item.create',
        'item': {
          'type': 'function_call_output',
          'call_id': callId,
          'output': jsonEncode(output),
        },
      });
      _channel?.sink.add(event);

      // Request a response after sending function output
      _requestResponse();

      _logger.i('Function call output sent for $callId');
    } catch (e) {
      _logger.e('Error sending function call output', error: e);
    }
  }

  /// Request a response from the API
  void _requestResponse() {
    if (!_isConnected) return;

    try {
      final event = jsonEncode({
        'type': 'response.create',
      });
      _channel?.sink.add(event);
      _logger.i('Response requested');
    } catch (e) {
      _logger.e('Error requesting response', error: e);
    }
  }

  /// Send a text message
  void sendTextMessage(String text) {
    if (!_isConnected) {
      _logger.w('Cannot send text: Not connected');
      return;
    }

    try {
      final event = jsonEncode({
        'type': 'conversation.item.create',
        'item': {
          'type': 'message',
          'role': 'user',
          'content': [
            {
              'type': 'input_text',
              'text': text,
            }
          ],
        },
      });
      _channel?.sink.add(event);

      // Request a response
      _requestResponse();

      _logger.i('Text message sent: $text');
      _transcriptController.add('You: $text');
    } catch (e) {
      _logger.e('Error sending text message', error: e);
    }
  }

  /// Cancel the current response
  void cancelResponse() {
    if (!_isConnected) return;

    try {
      final event = jsonEncode({
        'type': 'response.cancel',
      });
      _channel?.sink.add(event);
      _logger.i('Response cancelled');
    } catch (e) {
      _logger.e('Error cancelling response', error: e);
    }
  }

  /// Disconnect from the API
  Future<void> disconnect() async {
    try {
      await _channel?.sink.close();
      _isConnected = false;
      _connectionController.add(false);
      _statusController.add('Disconnected');
      _logger.i('Disconnected from OpenAI Realtime API');
    } catch (e) {
      _logger.e('Error disconnecting', error: e);
    }
  }

  /// Dispose of resources
  void dispose() {
    disconnect();
    _connectionController.close();
    _transcriptController.close();
    _audioController.close();
    _errorController.close();
    _statusController.close();
    _functionCallController.close();
    _functionCallBuffers.clear();
  }
}
