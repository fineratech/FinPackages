import 'package:flutter/material.dart';
import 'dart:async';
import 'package:logger/logger.dart';
import '../services/openai_realtime_service.dart';
import '../services/audio_service.dart';
import '../services/realtime_function_provider.dart';
import '../services/project_function_provider.dart';

class RealtimeVoiceScreen extends StatefulWidget {
  final ProjectFunctionProvider functionProvider;
  final String systemPrompt;
  final Color? backgroundColor;
  final Color? primaryColor;
  final Color? secondaryColor;
  final String apiKey;
  final String? title;

  const RealtimeVoiceScreen({
    super.key,
    required this.functionProvider,
    required this.systemPrompt,
    required this.apiKey,
    this.backgroundColor,
    this.primaryColor,
    this.secondaryColor,
    this.title,
  });

  @override
  State<RealtimeVoiceScreen> createState() => _RealtimeVoiceScreenState();
}

class _RealtimeVoiceScreenState extends State<RealtimeVoiceScreen>
    with TickerProviderStateMixin {
  final Logger _logger = Logger();

  late OpenAIRealtimeService _realtimeService;
  late AudioService _audioService;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;

  final List<String> _transcripts = [];
  final List<Map<String, dynamic>> _functionCalls = [];
  final ScrollController _scrollController = ScrollController();

  bool _isConnected = false;
  bool _isRecording = false;
  String _statusMessage = 'Ready to connect';
  bool _permissionGranted = false;

  // Visual state
  bool _isListening = false;
  bool _isProcessing = false;
  bool _isSpeaking = false;

  Color get _backgroundColor =>
      widget.backgroundColor ?? const Color(0xFF0A0E27);
  Color get _primaryColor => widget.primaryColor ?? const Color(0xFF6C5CE7);
  Color get _secondaryColor => widget.secondaryColor ?? const Color(0xFF00D9FF);
  String get _title => widget.title ?? 'Voice Assistant';

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _setupAnimations();
    _requestPermissions();
  }

  void _initializeServices() {
    final realtimeFunctionProvider = RealtimeFunctionProvider(
      projectFunctionProvider: widget.functionProvider,
    );

    _realtimeService = OpenAIRealtimeService(
      apiKey: widget.apiKey,
      functionProvider: realtimeFunctionProvider,
      systemPrompt: widget.systemPrompt,
    );

    _audioService = AudioService();

    // Listen to service streams
    _realtimeService.connectionStream.listen(_onConnectionChanged);
    _realtimeService.transcriptStream.listen(_onTranscriptReceived);
    _realtimeService.audioStream.listen(_onAudioReceived);
    _realtimeService.errorStream.listen(_onError);
    _realtimeService.statusStream.listen(_onStatusChanged);
    _realtimeService.functionCallStream.listen(_onFunctionCall);
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _requestPermissions() async {
    final granted = await _audioService.requestPermission();
    setState(() {
      _permissionGranted = granted;
      if (!granted) {
        _statusMessage = 'Microphone permission required';
      }
    });
  }

  void _onConnectionChanged(bool connected) {
    setState(() {
      _isConnected = connected;
      if (connected) {
        _startRecording();
      } else {
        _stopRecording();
      }
    });
  }

  void _onTranscriptReceived(String transcript) {
    setState(() {
      _transcripts.add(transcript);
    });
    _scrollToBottom();

    // Update visual state based on transcript
    if (transcript.startsWith('You:')) {
      setState(() {
        _isListening = false;
        _isProcessing = true;
      });
    } else if (transcript.startsWith('AI:')) {
      setState(() {
        _isProcessing = false;
        _isSpeaking = true;
      });
    }
  }

  void _onAudioReceived(dynamic audioData) {
    // Play received audio
    _audioService.playAudio(audioData);
  }

  void _onError(String error) {
    _logger.e('Realtime API error: $error');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $error'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onStatusChanged(String status) {
    setState(() {
      _statusMessage = status;
    });

    // Update visual states based on status
    if (status.contains('Listening')) {
      setState(() {
        _isListening = true;
        _isProcessing = false;
        _isSpeaking = false;
      });
    } else if (status.contains('Processing')) {
      setState(() {
        _isListening = false;
        _isProcessing = true;
        _isSpeaking = false;
      });
    } else if (status.contains('responding')) {
      setState(() {
        _isListening = false;
        _isProcessing = false;
        _isSpeaking = true;
      });
    } else if (status.contains('Ready')) {
      setState(() {
        _isListening = true;
        _isProcessing = false;
        _isSpeaking = false;
      });
    }
  }

  void _onFunctionCall(Map<String, dynamic> functionCall) {
    setState(() {
      _functionCalls.add(functionCall);
      _transcripts.add(
        'Function: ${functionCall['name']} with args ${functionCall['arguments']}',
      );
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _toggleConnection() async {
    if (_isConnected) {
      await _disconnect();
    } else {
      await _connect();
    }
  }

  Future<void> _connect() async {
    if (!_permissionGranted) {
      await _requestPermissions();
      if (!_permissionGranted) return;
    }

    try {
      setState(() {
        _statusMessage = 'Connecting...';
      });
      await _realtimeService.connect();
    } catch (e) {
      _logger.e('Connection error', error: e);
      setState(() {
        _statusMessage = 'Connection failed';
      });
    }
  }

  Future<void> _disconnect() async {
    await _stopRecording();
    await _realtimeService.disconnect();
    setState(() {
      _statusMessage = 'Disconnected';
    });
  }

  Future<void> _startRecording() async {
    if (_isRecording) return;

    try {
      await _audioService.startRecording((audioData) {
        _realtimeService.sendAudioData(audioData);
      });

      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      _logger.e('Recording error', error: e);
      _onError('Failed to start recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    await _audioService.stopRecording();
    setState(() {
      _isRecording = false;
    });
  }

  @override
  void dispose() {
    _disconnect();
    _realtimeService.dispose();
    _audioService.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white70),
            onPressed: () {
              setState(() {
                _transcripts.clear();
                _functionCalls.clear();
              });
            },
            tooltip: 'Clear conversation',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Transcript section
            Expanded(
              flex: 2,
              child: _buildTranscriptSection(),
            ),

            // Main visual indicator
            Expanded(
              flex: 3,
              child: _buildVisualIndicator(),
            ),

            // Status and controls
            _buildStatusSection(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTranscriptSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.chat_bubble_outline, color: _secondaryColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Conversation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _transcripts.isEmpty
                ? Center(
                    child: Text(
                      'Start talking to begin...',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 14,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _transcripts.length,
                    itemBuilder: (context, index) {
                      final transcript = _transcripts[index];
                      final isUser = transcript.startsWith('You:');
                      final isFunction = transcript.startsWith('Function:');

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          transcript,
                          style: TextStyle(
                            color: isFunction
                                ? _secondaryColor.withValues(alpha: 0.8)
                                : isUser
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.7),
                            fontSize: 13,
                            fontWeight: isFunction
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisualIndicator() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated waves when speaking
          if (_isSpeaking || _isListening)
            ...List.generate(3, (index) {
              return AnimatedBuilder(
                animation: _waveController,
                builder: (context, child) {
                  final delay = index * 0.2;
                  final scale =
                      1.0 + (1.5 * (((_waveController.value + delay) % 1.0)));
                  final opacity =
                      1.0 - (((_waveController.value + delay) % 1.0));

                  return Container(
                    width: 150 * scale,
                    height: 150 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: (_isSpeaking ? _primaryColor : _secondaryColor)
                            .withValues(alpha: opacity * 0.3),
                        width: 2,
                      ),
                    ),
                  );
                },
              );
            }),

          // Main indicator circle
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isConnected ? _pulseAnimation.value : 1.0,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: _isConnected
                          ? [
                              _isSpeaking
                                  ? _primaryColor
                                  : _isProcessing
                                      ? Colors.amber
                                      : _secondaryColor,
                              _isSpeaking
                                  ? _primaryColor.withValues(alpha: 0.3)
                                  : _isProcessing
                                      ? Colors.amber.withValues(alpha: 0.3)
                                      : _secondaryColor.withValues(alpha: 0.3),
                            ]
                          : [
                              Colors.grey.shade700,
                              Colors.grey.shade800,
                            ],
                    ),
                    boxShadow: _isConnected
                        ? [
                            BoxShadow(
                              color: (_isSpeaking
                                      ? _primaryColor
                                      : _secondaryColor)
                                  .withValues(alpha: 0.5),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(
                    _isSpeaking
                        ? Icons.volume_up
                        : _isProcessing
                            ? Icons.psychology
                            : _isListening
                                ? Icons.mic
                                : Icons.mic_off,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    return Column(
      children: [
        // Status text
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isConnected ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _statusMessage,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Connect/Disconnect button
        GestureDetector(
          onTap: _permissionGranted ? _toggleConnection : _requestPermissions,
          child: Container(
            width: 200,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isConnected
                    ? [Colors.red.shade400, Colors.red.shade600]
                    : [_primaryColor, _secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: (_isConnected ? Colors.red : _primaryColor)
                      .withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isConnected ? Icons.stop : Icons.play_arrow,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isConnected ? 'Disconnect' : 'Connect',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
