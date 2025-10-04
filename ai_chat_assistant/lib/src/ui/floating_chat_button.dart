import 'package:flutter/material.dart';
import 'chat_screen.dart';
import '../services/chat_agent_service.dart';

class FloatingChatButton extends StatefulWidget {
  final ChatAgentService chatService;
  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? iconColor;
  final double? bottom;
  final double? right;
  final Color? backgroundColor;
  final Color? appBarColor;

  const FloatingChatButton({
    super.key,
    required this.chatService,
    this.primaryColor,
    this.secondaryColor,
    this.iconColor,
    this.bottom,
    this.right,
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

  Color get _primaryColor => widget.primaryColor ?? const Color(0xFF000000);
  Color get _secondaryColor => widget.secondaryColor ?? const Color(0xFF333333);
  Color get _iconColor => widget.iconColor ?? const Color(0xFFFFFFFF);

  @override
  void initState() {
    super.initState();

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
            chatService: widget.chatService,
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
    return Positioned(
      bottom: widget.bottom ?? 100,
      right: widget.right ?? 20,
      child: AnimatedBuilder(
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
                    color: _primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.1),
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
      ),
    );
  }
}
