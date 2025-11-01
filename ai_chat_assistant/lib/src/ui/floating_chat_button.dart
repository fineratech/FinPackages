import 'package:flutter/material.dart';
import 'package:fin_api_functions/fin_api_functions.dart';
import 'chat_screen.dart';
import '../services/chat_agent_service.dart';
import '../config/openai_config.dart';
import '../config/project_type.dart';
import '../config/chat_agent_config.dart';

class FloatingChatButton extends StatefulWidget {
  /// OpenAI API key for authentication
  final String apiKey;

  /// Project type for context-specific assistance
  final ProjectType projectType;

  /// API functions service for backend operations
  final ApiFunctionsService apiFunctionsService;

  /// Optional chat agent configuration
  final ChatAgentConfig? config;

  /// Primary color for the floating button gradient
  final Color? primaryColor;

  /// Secondary color for the floating button gradient
  final Color? secondaryColor;

  /// Icon color for the chat icon
  final Color? iconColor;

  /// Background color for the chat screen
  final Color? backgroundColor;

  /// App bar color for the chat screen
  final Color? appBarColor;

  const FloatingChatButton({
    super.key,
    required this.apiKey,
    required this.projectType,
    required this.apiFunctionsService,
    this.config,
    this.primaryColor,
    this.secondaryColor,
    this.iconColor,
    this.backgroundColor,
    this.appBarColor,
  });

  @override
  State<FloatingChatButton> createState() => _FloatingChatButtonState();
}

class _FloatingChatButtonState extends State<FloatingChatButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  late ChatAgentService _chatService;

  Color get _primaryColor => widget.primaryColor ?? const Color(0xFF000000);
  Color get _secondaryColor => widget.secondaryColor ?? const Color(0xFF333333);
  Color get _iconColor => widget.iconColor ?? const Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();

    // Initialize OpenAI configuration
    OpenAIConfig.setApiKey(widget.apiKey);

    // Initialize chat service
    _chatService = ChatAgentService(
      projectType: widget.projectType,
      apiFunctionsService: widget.apiFunctionsService,
      config: widget.config,
    );

    // Pulse animation for the button
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Scale animation for tap feedback
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    // Start pulse animation
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onTap() async {
    // Scale animation feedback
    await _scaleController.forward();
    _scaleController.reverse();

    // Navigate to chat screen
    if (mounted) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => ChatScreen(
            chatService: _chatService,
            backgroundColor: widget.backgroundColor,
            appBarColor: widget.appBarColor,
            primaryColor: widget.primaryColor ?? _primaryColor,
            secondaryColor: widget.secondaryColor ?? _secondaryColor,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _scaleAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _primaryColor,
                  _secondaryColor,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: _primaryColor.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: _primaryColor.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: _onTap,
                child: Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chat_bubble_outline,
                      color: _iconColor,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
