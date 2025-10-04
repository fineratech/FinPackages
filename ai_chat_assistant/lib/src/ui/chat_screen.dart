import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../services/chat_agent_service.dart';
import '../models/chat_message.dart';

class ChatScreen extends StatefulWidget {
  final ChatAgentService chatService;
  final Color? backgroundColor;
  final Color? appBarColor;
  final Color? primaryColor;
  final Color? secondaryColor;
  final String? title;
  final String? onlineStatus;
  final String? welcomeMessage;

  const ChatScreen({
    super.key,
    required this.chatService,
    this.backgroundColor,
    this.appBarColor,
    this.primaryColor,
    this.secondaryColor,
    this.title,
    this.onlineStatus,
    this.welcomeMessage,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final Logger _logger = Logger();

  Color get _backgroundColor => widget.backgroundColor ?? const Color(0xFFF5F5F5);
  Color get _appBarColor => widget.appBarColor ?? const Color(0xFFFFFFFF);
  Color get _primaryColor => widget.primaryColor ?? const Color(0xFF000000);
  Color get _secondaryColor => widget.secondaryColor ?? const Color(0xFF808080);
  String get _title => widget.title ?? widget.chatService.chatTitle;
  String get _onlineStatus => widget.onlineStatus ?? 'Online';
  String get _welcomeMessage => widget.welcomeMessage ?? widget.chatService.welcomeMessage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Add welcome message
    _addMessage(_welcomeMessage, false);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _addMessage(String content, bool isUser) {
    setState(() {
      _messages.add(ChatMessage(
        content: content,
        isUser: isUser,
        timestamp: DateTime.now(),
      ));
    });
    _animationController.forward();
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

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _addMessage(message, true);
    _messageController.clear();

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await widget.chatService.sendMessage(message, _messages);
      _addMessage(response, false);
    } catch (e) {
      _logger.e('Send message error', error: e);
      _addMessage('Sorry, I encountered an error. Please try again.', false);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy,
                color: Color(0xFFFFFFFF),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _primaryColor,
                  ),
                ),
                Text(
                  _onlineStatus,
                  style: TextStyle(
                    fontSize: 12,
                    color: _secondaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: _appBarColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildMessageBubble(message),
                );
              },
            ),
          ),
          if (_isLoading) _buildTypingIndicator(),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: _primaryColor,
              child: const Icon(
                Icons.smart_toy,
                color: Color(0xFFFFFFFF),
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isUser ? _primaryColor : const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(18).copyWith(
                  bottomLeft: message.isUser
                      ? const Radius.circular(18)
                      : const Radius.circular(4),
                  bottomRight: message.isUser
                      ? const Radius.circular(4)
                      : const Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: message.isUser
                      ? const Color(0xFFFFFFFF)
                      : _primaryColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF2196F3),
              child: const Icon(
                Icons.person,
                color: Color(0xFFFFFFFF),
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: _primaryColor,
            child: const Icon(
              Icons.smart_toy,
              color: Color(0xFFFFFFFF),
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final value = (_animationController.value * 3 - index).clamp(0.0, 1.0);
        return Transform.scale(
          scale: 0.8 + (0.4 * value),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _secondaryColor.withOpacity(0.5 + (0.5 * value)),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _appBarColor,
        border: Border(
          top: BorderSide(color: _secondaryColor, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: _backgroundColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  controller: _messageController,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Type your message...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _messageController.text.trim().isNotEmpty
                    ? _primaryColor
                    : _secondaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.send,
                  color: Color(0xFFFFFFFF),
                  size: 20,
                ),
                onPressed: _isLoading ? null : _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
