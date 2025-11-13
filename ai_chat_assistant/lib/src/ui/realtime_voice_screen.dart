import 'package:flutter/material.dart';
import 'dart:async';
import 'package:logger/logger.dart';
import '../services/openai_realtime_webrtc_service.dart';
import '../services/realtime_function_provider.dart';
import '../services/project_function_provider.dart';

class RealtimeVoiceScreen extends StatefulWidget {
  final ProjectFunctionProvider functionProvider;
  final String systemPrompt;
  final Color? backgroundColor;
  final Color? primaryColor;
  final Color? accentColor;
  final String apiKey;

  const RealtimeVoiceScreen({
    super.key,
    required this.functionProvider,
    required this.systemPrompt,
    required this.apiKey,
    this.backgroundColor,
    this.primaryColor,
    this.accentColor,
  });

  @override
  State<RealtimeVoiceScreen> createState() => _RealtimeVoiceScreenState();
}

enum VoiceState {
  connecting,
  listening,
  processing,
  speaking,
  error,
}

class _RealtimeVoiceScreenState extends State<RealtimeVoiceScreen>
    with TickerProviderStateMixin {
  final Logger _logger = Logger();

  late OpenAIRealtimeWebRTCService _realtimeService;
  late AnimationController _pulseController;
  late AnimationController _waveController;

  VoiceState _currentState = VoiceState.connecting;
  String _statusMessage = 'Connecting...';
  bool _isMuted = false;

  Color get _backgroundColor =>
      widget.backgroundColor ?? const Color(0xFF000000);
  Color get _primaryColor => widget.primaryColor ?? const Color(0xFFFFFFFF);
  Color get _accentColor => widget.accentColor ?? const Color(0xFFCE6918);

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _setupAnimations();
    // Auto-start connection
    Future.delayed(const Duration(milliseconds: 500), () {
      _connect();
    });
  }

  void _initializeServices() {
    final realtimeFunctionProvider = RealtimeFunctionProvider(
      projectFunctionProvider: widget.functionProvider,
    );

    _realtimeService = OpenAIRealtimeWebRTCService(
      apiKey: widget.apiKey,
      functionProvider: realtimeFunctionProvider,
      systemPrompt: widget.systemPrompt,
    );

    // Listen to service streams
    _realtimeService.connectionStream.listen(_onConnectionChanged);
    _realtimeService.transcriptStream.listen(_onTranscriptReceived);
    _realtimeService.errorStream.listen(_onError);
    _realtimeService.statusStream.listen(_onStatusChanged);
    _realtimeService.functionCallStream.listen(_onFunctionCall);
  }

  void _onFunctionCall(Map<String, dynamic> functionCall) {
    _logger.i('Function call: ${functionCall['name']}');
    // Function calls are automatically handled by the service
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
  }

  void _onConnectionChanged(bool connected) {
    setState(() {
      if (connected) {
        _currentState = VoiceState.listening;
        _statusMessage = 'Listening...';
      }
    });
  }

  void _onTranscriptReceived(String transcript) {
    _logger.i('Transcript: $transcript');
  }

  void _onError(String error) {
    _logger.e('Error: $error');
    setState(() {
      _currentState = VoiceState.error;
      _statusMessage = 'Connection failed';
    });
  }

  void _onStatusChanged(String status) {
    setState(() {
      _statusMessage = status;

      // Update state based on status
      if (status.toLowerCase().contains('listening')) {
        _currentState = VoiceState.listening;
      } else if (status.toLowerCase().contains('processing')) {
        _currentState = VoiceState.processing;
      } else if (status.toLowerCase().contains('speaking')) {
        _currentState = VoiceState.speaking;
      } else if (status.toLowerCase().contains('ready')) {
        _currentState = VoiceState.listening;
      }
    });
  }

  Future<void> _connect() async {
    try {
      await _realtimeService.connect();
    } catch (e) {
      _logger.e('Connection error', error: e);
    }
  }

  Future<void> _disconnect() async {
    await _realtimeService.disconnect();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
    _realtimeService.toggleMicrophone(!_isMuted);
  }

  void _retry() {
    setState(() {
      _currentState = VoiceState.connecting;
      _statusMessage = 'Connecting...';
    });
    _connect();
  }

  @override
  void dispose() {
    _disconnect();
    _realtimeService.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await _disconnect();
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: _backgroundColor,
        body: Container(
          decoration: BoxDecoration(
            color: _backgroundColor,
            border: _currentState == VoiceState.listening
                ? Border.all(
                    color: _accentColor,
                    width: 14,
                    strokeAlign: BorderSide.strokeAlignCenter,
                  )
                : null,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Spacer(),
                  // Main animation area
                  _buildStateAnimation(),
                  const SizedBox(height: 20),
                  // Status text
                  _buildStatusText(),
                  const Spacer(),
                  // Error retry button
                  if (_currentState == VoiceState.error) ...[
                    GestureDetector(
                      onTap: _retry,
                      child: Text(
                        'Connection failed. Tap to retry',
                        style: TextStyle(
                          color: Colors.red.shade400,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 42),
                  ] else
                    const SizedBox(height: 42),
                  // Bottom controls
                  Row(
                    children: [
                      _buildCircularButton(
                        icon: Icons.close,
                        backgroundColor: _primaryColor.withValues(alpha: 0.1),
                        iconColor: _primaryColor,
                        onTap: () async {
                          await _disconnect();
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                      const Spacer(),
                      _buildCircularButton(
                        icon: _isMuted ? Icons.mic_off : Icons.mic,
                        backgroundColor: _primaryColor,
                        iconColor: _isMuted
                            ? _primaryColor.withValues(alpha: 0.3)
                            : Colors.white,
                        onTap: _toggleMute,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStateAnimation() {
    switch (_currentState) {
      case VoiceState.connecting:
      case VoiceState.processing:
        return _buildLoadingAnimation();
      case VoiceState.listening:
        return _buildListeningAnimation();
      case VoiceState.speaking:
        return _buildSpeakingAnimation();
      case VoiceState.error:
        return _buildErrorAnimation();
    }
  }

  Widget _buildLoadingAnimation() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _primaryColor.withValues(alpha: 0.1 + (_pulseController.value * 0.2)),
          ),
          child: Center(
            child: Icon(
              Icons.motion_photos_on,
              size: 80,
              color: _primaryColor.withValues(alpha: 0.5 + (_pulseController.value * 0.5)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListeningAnimation() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer ripple
            Container(
              width: 200 + (_waveController.value * 40),
              height: 200 + (_waveController.value * 40),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _accentColor.withValues(alpha: 1 - _waveController.value),
                  width: 3,
                ),
              ),
            ),
            // Middle ripple
            Container(
              width: 180 + (_waveController.value * 30),
              height: 180 + (_waveController.value * 30),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _accentColor.withValues(alpha: (1 - _waveController.value) * 0.7),
                  width: 2,
                ),
              ),
            ),
            // Center circle
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _accentColor.withValues(alpha: 0.3),
                    _accentColor.withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.mic,
                  size: 80,
                  color: _accentColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSpeakingAnimation() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 1.0 + (_pulseController.value * 0.15);
        return Transform.scale(
          scale: scale,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  _primaryColor.withValues(alpha: 0.3),
                  _primaryColor.withValues(alpha: 0.1),
                ],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.graphic_eq,
                size: 80,
                color: _primaryColor,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorAnimation() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red.withValues(alpha: 0.1),
      ),
      child: Center(
        child: Icon(
          Icons.error_outline,
          size: 80,
          color: Colors.red.shade400,
        ),
      ),
    );
  }

  Widget _buildStatusText() {
    if (_currentState == VoiceState.connecting ||
        _currentState == VoiceState.processing) {
      return Column(
        children: [
          Text(
            _currentState == VoiceState.connecting ? 'Connecting...' : 'Processing...',
            style: TextStyle(
              color: _primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
            ),
          ),
          if (_currentState == VoiceState.processing) ...[
            const SizedBox(height: 20),
            Text(
              'Please wait while AI processes your request',
              style: TextStyle(
                color: _primaryColor.withValues(alpha: 0.8),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      );
    } else if (_currentState == VoiceState.listening) {
      return Text(
        'Listening...',
        style: TextStyle(
          color: _primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w400,
          fontStyle: FontStyle.italic,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildCircularButton({
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 62,
        height: 62,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.transparent),
        ),
        child: Center(
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ),
      ),
    );
  }
}
