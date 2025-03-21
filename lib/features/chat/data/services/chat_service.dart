import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  // Mock responses for development
  final List<String> mockResponses = [
    "Hi, how can I assist you today?",
    "I understand. Could you please provide more details?",
    "That's interesting! Let me help you with that.",
    "Is there anything specific you'd like to know?",
    "I'm here to help! What would you like to discuss?",
  ];

  Future<String> sendMessage(String message) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Return random response from mock list
    return mockResponses[DateTime.now().second % mockResponses.length];
  }
} 