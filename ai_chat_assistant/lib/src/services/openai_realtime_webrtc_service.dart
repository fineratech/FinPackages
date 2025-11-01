import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:logger/logger.dart';
import 'realtime_function_provider.dart';

/// WebRTC-based service for OpenAI Realtime API
/// Much smoother than WebSocket due to direct audio streaming
class OpenAIRealtimeWebRTCService {
  final String apiKey;
  final RealtimeFunctionProvider functionProvider;
  final String systemPrompt;
  final Logger _logger = Logger();

  RTCPeerConnection? _peerConnection;
  RTCDataChannel? _dataChannel;
  MediaStream? _localStream;
  MediaStream? _remoteStream;
  RTCVideoRenderer? _remoteRenderer;

  bool _isConnected = false;
  String? _sessionId;

  // Stream controllers for events
  final _connectionController = StreamController<bool>.broadcast();
  final _transcriptController = StreamController<String>.broadcast();
  final _errorController = StreamController<String>.broadcast();
  final _statusController = StreamController<String>.broadcast();
  final _functionCallController =
      StreamController<Map<String, dynamic>>.broadcast();

  // Buffers for function call arguments
  final Map<String, StringBuffer> _functionCallBuffers = {};

  Stream<bool> get connectionStream => _connectionController.stream;
  Stream<String> get transcriptStream => _transcriptController.stream;
  Stream<String> get errorStream => _errorController.stream;
  Stream<String> get statusStream => _statusController.stream;
  Stream<Map<String, dynamic>> get functionCallStream =>
      _functionCallController.stream;

  bool get isConnected => _isConnected;

  OpenAIRealtimeWebRTCService({
    required this.apiKey,
    required this.functionProvider,
    required this.systemPrompt,
  });

  /// Connect to OpenAI Realtime API via WebRTC
  Future<void> connect() async {
    try {
      _statusController.add('Connecting to OpenAI Realtime API...');
      _logger.i('Starting WebRTC connection');

      // Initialize remote renderer for audio playback
      _remoteRenderer = RTCVideoRenderer();
      await _remoteRenderer!.initialize();
      _logger.i('Remote renderer initialized');

      // Initialize peer connection with STUN server
      _peerConnection = await createPeerConnection({
        'iceServers': [
          {'urls': 'stun:stun.l.google.com:19302'},
        ],
      });

      if (_peerConnection == null) {
        throw Exception('Failed to initialize peer connection');
      }
      _logger.i('Peer connection initialized');

      // Get local audio stream with optimal settings
      _localStream = await navigator.mediaDevices.getUserMedia({
        'audio': {
          'echoCancellation': true,
          'noiseSuppression': true,
          'autoGainControl': true,
          'sampleRate': 24000,
          'channelCount': 1,
        },
        'video': false,
      });

      if (_localStream == null) {
        throw Exception('Failed to get local audio stream');
      }
      _logger.i('Got local audio stream');

      // Add audio tracks to peer connection
      _localStream!.getTracks().forEach((track) {
        _peerConnection!.addTrack(track, _localStream!);
        _logger.d('Added track: ${track.kind}');
      });

      // Create data channel for events (like function calls)
      _dataChannel = await _peerConnection!
          .createDataChannel('oai-events', RTCDataChannelInit());

      if (_dataChannel == null) {
        throw Exception('Failed to create data channel');
      }
      _logger.i('Data channel created');

      // Create offer
      RTCSessionDescription offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);
      _logger.i('Created and set local description (offer)');

      // Send SDP to OpenAI and get answer
      final remoteSdp = await _sendSDPToServer(offer.sdp!);
      RTCSessionDescription answer = RTCSessionDescription(remoteSdp, 'answer');
      await _peerConnection!.setRemoteDescription(answer);
      _logger.i('Set remote description (answer)');

      // Configure callbacks
      _configureCallbacks();

      _isConnected = true;
      _connectionController.add(true);
      _statusController.add('Connected! Start speaking...');
      _logger.i('WebRTC connection established successfully');
    } catch (e) {
      _logger.e('Failed to connect via WebRTC', error: e);
      _errorController.add('Connection failed: $e');
      _statusController.add('Connection failed');
      _isConnected = false;
      _connectionController.add(false);
      _cleanupConnection();
    }
  }

  /// Send SDP offer to OpenAI and get answer
  Future<String> _sendSDPToServer(String sdp) async {
    final url = Uri.parse('https://api.openai.com/v1/realtime?model=gpt-realtime');

    try {
      final client = HttpClient();
      final request = await client.postUrl(url);

      request.headers.set('Authorization', 'Bearer $apiKey');
      request.headers.set('Content-Type', 'application/sdp');

      request.write(sdp);

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      // Accept both 200 (OK) and 201 (Created) as success
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          responseBody.isNotEmpty) {
        _logger.i('Received SDP answer from server (${response.statusCode})');
        return responseBody;
      } else {
        throw Exception(
            'Server returned ${response.statusCode}: $responseBody');
      }
    } catch (e) {
      _logger.e('Error sending SDP', error: e);
      throw Exception('Error sending SDP: $e');
    }
  }

  /// Configure session with system prompt and function definitions
  void _configureSession() {
    if (_dataChannel == null) return;

    try {
      _dataChannel!.send(RTCDataChannelMessage(jsonEncode({
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
      })));
      _logger.i('Session configuration sent');
    } catch (e) {
      _logger.e('Error configuring session', error: e);
    }
  }

  /// Configure WebRTC callbacks
  void _configureCallbacks() {
    // Data channel message handler
    _dataChannel?.onMessage = (RTCDataChannelMessage message) {
      if (message.isBinary) {
        return;
      }

      try {
        final jsonData = jsonDecode(message.text);
        final eventType = jsonData['type'] as String?;

        _logger.d('Received event: $eventType');

        switch (eventType) {
          case 'session.created':
            _sessionId = jsonData['session']?['id'];
            _logger.i('Session created: $_sessionId');
            // Configure session with system prompt and functions
            _configureSession();
            break;

          case 'session.updated':
            _logger.i('Session configured successfully');
            // Now send initial response create event
            _dataChannel!.send(RTCDataChannelMessage(
                jsonEncode({'type': 'response.create'})));
            _statusController.add('Ready - Start speaking...');
            break;

          case 'input_audio_buffer.speech_started':
            _statusController.add('Listening...');
            break;

          case 'input_audio_buffer.speech_stopped':
            _statusController.add('Processing...');
            break;

          case 'output_audio_buffer.started':
            _statusController.add('AI is speaking...');
            break;

          case 'output_audio_buffer.stopped':
            _statusController.add('Ready');
            break;

          case 'conversation.item.input_audio_transcription.completed':
            final transcript = jsonData['transcript'] as String?;
            if (transcript != null && transcript.isNotEmpty) {
              _logger.i('User said: $transcript');
              _transcriptController.add('You: $transcript');
            }
            break;

          case 'response.audio_transcript.done':
            final transcript = jsonData['transcript'] as String?;
            if (transcript != null && transcript.isNotEmpty) {
              _logger.i('AI said: $transcript');
              _transcriptController.add('AI: $transcript');
            }
            break;

          case 'response.function_call_arguments.delta':
            _handleFunctionCallArgumentsDelta(jsonData);
            break;

          case 'response.function_call_arguments.done':
            _handleFunctionCallArgumentsDone(jsonData);
            break;

          case 'response.done':
            final response = jsonData['response'];
            if (response?['status'] == 'failed') {
              _errorController.add('Response failed');
            }
            break;

          case 'error':
            _handleApiError(jsonData);
            break;

          default:
            _logger.d('Unhandled event type: $eventType');
        }
      } catch (e) {
        _logger.e('Error processing message', error: e);
      }
    };

    // Remote stream handler (AI audio output)
    _peerConnection?.onAddStream = (MediaStream stream) {
      _logger.i('Received remote audio stream');
      _remoteStream = stream;

      // Set up the stream for playback
      if (_remoteRenderer != null) {
        _remoteRenderer!.srcObject = stream;
        _logger.i('Remote stream attached to renderer');
      }

      final audioTracks = stream.getAudioTracks();
      if (audioTracks.isNotEmpty) {
        _logger.i('Remote audio track available: ${audioTracks.length} track(s)');

        // Enable all audio tracks and set volume to maximum
        for (var track in audioTracks) {
          track.enabled = true;
          // Set volume to maximum (range is typically 0.0 to 1.0)
          Helper.setVolume(1.0, track);
          _logger.i('Audio track enabled with maximum volume');
        }

        _statusController.add('Audio stream ready');
      }
    };

    // ICE connection state handler
    _peerConnection?.onIceConnectionState = (RTCIceConnectionState state) {
      _logger.d('ICE connection state: $state');
      if (state == RTCIceConnectionState.RTCIceConnectionStateFailed ||
          state == RTCIceConnectionState.RTCIceConnectionStateDisconnected ||
          state == RTCIceConnectionState.RTCIceConnectionStateClosed) {
        _errorController.add('Connection lost: $state');
        _statusController.add('Disconnected');
        _isConnected = false;
        _connectionController.add(false);
      }
    };

    // Data channel state handler
    _dataChannel?.onDataChannelState = (RTCDataChannelState state) {
      _logger.d('Data channel state: $state');
      if (state == RTCDataChannelState.RTCDataChannelOpen) {
        _logger.i('Data channel is now open - ready to send messages');
        // The session.created event will trigger configuration
      } else if (state == RTCDataChannelState.RTCDataChannelClosed ||
          state == RTCDataChannelState.RTCDataChannelClosing) {
        _errorController.add('Data channel closed');
        _isConnected = false;
        _connectionController.add(false);
      }
    };
  }

  /// Handle function call arguments delta
  void _handleFunctionCallArgumentsDelta(Map<String, dynamic> data) {
    final callId = data['call_id'] as String?;
    final delta = data['delta'] as String?;

    if (callId != null && delta != null) {
      _functionCallBuffers.putIfAbsent(callId, () => StringBuffer());
      _functionCallBuffers[callId]!.write(delta);
    }
  }

  /// Handle function call arguments done
  void _handleFunctionCallArgumentsDone(Map<String, dynamic> data) async {
    final callId = data['call_id'] as String?;
    final arguments = data['arguments'] as String?;
    final functionName = data['name'] as String?;

    if (callId != null && functionName != null) {
      final finalArguments =
          arguments ?? _functionCallBuffers[callId]?.toString() ?? '{}';
      _functionCallBuffers.remove(callId);

      _logger.i('Function call: $functionName');
      _statusController.add('Executing: $functionName');

      try {
        final argsJson = jsonDecode(finalArguments) as Map<String, dynamic>;

        _functionCallController.add({
          'name': functionName,
          'arguments': argsJson,
          'call_id': callId,
        });

        // Execute function
        final result =
            await functionProvider.executeFunction(functionName, argsJson);

        // Send result back via data channel
        _dataChannel?.send(RTCDataChannelMessage(jsonEncode({
          'type': 'conversation.item.create',
          'item': {
            'type': 'function_call_output',
            'call_id': callId,
            'output': jsonEncode(result),
          },
        })));

        // Request new response
        _dataChannel?.send(RTCDataChannelMessage(
            jsonEncode({'type': 'response.create'})));

        _logger.i('Function result sent');
      } catch (e) {
        _logger.e('Error executing function', error: e);
        _dataChannel?.send(RTCDataChannelMessage(jsonEncode({
          'type': 'conversation.item.create',
          'item': {
            'type': 'function_call_output',
            'call_id': callId,
            'output': jsonEncode({'error': 'Failed to execute: $e'}),
          },
        })));
      }
    }
  }

  /// Handle API errors
  void _handleApiError(Map<String, dynamic> data) {
    final error = data['error'];
    final message = error?['message'] ?? 'Unknown error';
    _logger.e('API Error: $message');
    _errorController.add(message);
    _statusController.add('Error: $message');
  }

  /// Send text message (optional - for debugging)
  void sendTextMessage(String text) {
    if (!_isConnected || _dataChannel == null) return;

    try {
      _dataChannel!.send(RTCDataChannelMessage(jsonEncode({
        'type': 'conversation.item.create',
        'item': {
          'type': 'message',
          'role': 'user',
          'content': [
            {'type': 'input_text', 'text': text}
          ],
        },
      })));

      _dataChannel!.send(
          RTCDataChannelMessage(jsonEncode({'type': 'response.create'})));

      _transcriptController.add('You: $text');
    } catch (e) {
      _logger.e('Error sending text message', error: e);
    }
  }

  /// Toggle microphone
  void toggleMicrophone(bool enabled) {
    _localStream?.getAudioTracks().forEach((track) {
      track.enabled = enabled;
    });
    _logger.i('Microphone ${enabled ? 'enabled' : 'disabled'}');
  }

  /// Set speaker volume (0.0 to 1.0)
  void setSpeakerVolume(double volume) {
    if (volume < 0.0 || volume > 1.0) {
      _logger.w('Volume must be between 0.0 and 1.0, got $volume');
      return;
    }

    _remoteStream?.getAudioTracks().forEach((track) {
      Helper.setVolume(volume, track);
    });
    _logger.i('Speaker volume set to $volume');
  }

  /// Clean up connection
  void _cleanupConnection() {
    _dataChannel?.close();
    _dataChannel = null;

    _peerConnection?.close();
    _peerConnection = null;

    _localStream?.dispose();
    _localStream = null;

    _remoteStream?.dispose();
    _remoteStream = null;

    _remoteRenderer?.dispose();
    _remoteRenderer = null;

    _isConnected = false;
    _logger.i('WebRTC connection cleaned up');
  }

  /// Disconnect
  Future<void> disconnect() async {
    try {
      _cleanupConnection();
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
    _errorController.close();
    _statusController.close();
    _functionCallController.close();
    _functionCallBuffers.clear();
  }
}
