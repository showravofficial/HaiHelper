import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/services/chat_service.dart';
import '../../../../core/widgets/custom_bottom_nav_bar.dart';

// Message model
class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? filePath;
  final String? fileName;
  final String? status;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.filePath,
    this.fileName,
    this.status,
  });
}

// Initial messages
final List<ChatMessage> initialMessages = [
  ChatMessage(
    id: '1',
    text: "Hi, how are you doing today?",
    isUser: false,
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
  ),
  ChatMessage(
    id: '2',
    text: "I'm doing great, thanks for asking!",
    isUser: true,
    timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
  ),
  ChatMessage(
    id: '3',
    text: "That's wonderful! How can I help you today?",
    isUser: false,
    timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
  ),
];

// Providers
final chatServiceProvider = Provider((ref) => ChatService());
final chatMessagesProvider = StateProvider<List<ChatMessage>>((ref) => []);
final messageProvider = StateProvider<String>((ref) => '');
final isLoadingProvider = StateProvider<bool>((ref) => false);

String getBotResponse(String userMessage) {
  userMessage = userMessage.toLowerCase();
  
  if (userMessage.contains('hello') || userMessage.contains('hi')) {
    return "Hi! How are you doing today?";
  } else if (userMessage.contains('how are you')) {
    return "I'm Great! You?";
  } else if (userMessage.contains('help')) {
    return "I'm here to help! What would you like to know?";
  } else if (userMessage.contains('thank')) {
    return "You're welcome! Is there anything else I can help you with?";
  } else if (userMessage.contains('bye')) {
    return "Goodbye! Have a great day!";
  } else if (userMessage.contains('good') || userMessage.contains('great')) {
    return "That's wonderful to hear! How can I assist you today?";
  } else {
    return "I understand. Please let me know how I can help you further.";
  }
}

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  Future<void> _pickFile(WidgetRef ref) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final newMessage = ChatMessage(
          id: DateTime.now().toString(),
          text: "📎 Attached image: ${image.name}",
          isUser: true,
          timestamp: DateTime.now(),
          filePath: image.path,
          fileName: image.name,
        );

        ref.read(chatMessagesProvider.notifier).state = [
          ...ref.read(chatMessagesProvider),
          newMessage,
        ];

        // Simulate bot response
        Future.delayed(const Duration(seconds: 1), () {
          final botResponse = ChatMessage(
            id: DateTime.now().toString(),
            text: "I received your image: ${image.name}",
            isUser: false,
            timestamp: DateTime.now(),
          );
          ref.read(chatMessagesProvider.notifier).state = [
            ...ref.read(chatMessagesProvider),
            botResponse,
          ];
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void sendMessage(BuildContext context, String message, WidgetRef ref) {
    if (message.trim().isEmpty) return;

    try {
      final userMessage = ChatMessage(
        id: DateTime.now().toString(),
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      );
      
      final botMessage = ChatMessage(
        id: DateTime.now().toString(),
        text: "Hi, how are you doing today",
        isUser: false,
        timestamp: DateTime.now(),
      );

      ref.read(chatMessagesProvider.notifier).state = [
        ...ref.read(chatMessagesProvider),
        userMessage,
        botMessage,
      ];
      ref.read(messageProvider.notifier).state = '';
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(chatMessagesProvider);
    final message = ref.watch(messageProvider);
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (messages.isEmpty) ...[
                    const SizedBox(width: 40),
                    const Text(
                      'Chat',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xFF7B6EF6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 40),
                  ] else ...[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xFF7B6EF6).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF7B6EF6),
                          size: 20,
                        ),
                        onPressed: () => context.pop(),
                      ),
                    ),
                    const Column(
                      children: [
                        Text(
                          'Hai',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF7B6EF6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '12226 Limited',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xff7872FF),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.history,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => context.push('/history'),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Chat Content
            Expanded(
              child: messages.isEmpty
                  ? Center(
                      child: Text(
                        'How can i help with?',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        return MessageBubble(message: msg);
                      },
                    ),
            ),

            // Message Input
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(left: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFF7B6EF6).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.attach_file_rounded,
                          color: Color(0xFF7B6EF6),
                          size: 20,
                        ),
                        onPressed: () => _pickFile(ref),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Type in your message here',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (value) {
                          ref.read(messageProvider.notifier).state = value;
                        },
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF7B6EF6),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => sendMessage(context, message, ref),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFF7B6EF6),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'Hai',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.6,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: message.isUser ? Color(0xFF7B6EF6) : Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage('https://via.placeholder.com/32'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
} 