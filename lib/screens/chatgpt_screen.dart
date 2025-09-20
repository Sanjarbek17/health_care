import 'package:chat_gpt_sdk/chat_gpt_sdk.dart' hide Assistant;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/message_model.dart';
import '../widgets/chatgpt_widget.dart';
import 'package:provider/provider.dart';
import '../utils/api_config.dart';

import '../providers/message_provider.dart';

/// Chat screen with secure API key management
/// API keys are loaded from environment variables for security
class Chat extends StatefulWidget {
  const Chat({super.key});
  static const routeName = 'chat';

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late final OpenAI? openAI;
  TextEditingController controller = TextEditingController();
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeOpenAI();
    // Add listener to update UI when text changes
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _initializeOpenAI() {
    try {
      if (!ApiConfig.isOpenAIConfigured) {
        setState(() {
          errorMessage = 'OpenAI API key not found. Please set OPENAI_API_KEY in your .env file.';
        });
        openAI = null;
        return;
      }

      openAI = OpenAI.instance.build(
        token: ApiConfig.openAIApiKey!,
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 30)),
        enableLog: true,
      );

      setState(() {
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to initialize OpenAI: ${e.toString()}';
      });
      openAI = null;
    }
  }

  void chatCompleteWithSSE() {
    if (openAI == null) {
      setState(() {
        errorMessage = 'OpenAI is not properly initialized. Please check your API key.';
      });
      return;
    }

    try {
      List<MessageProvider> messagesProvider = Provider.of<MessagesProvider>(context, listen: false).messages;

      // Create system message for medical assistant
      final systemMessage = {
        'role': 'system',
        'content': '''You are a professional medical assistant AI designed to help with healthcare-related questions and concerns. 

Your role and guidelines:
- You are a knowledgeable medical assistant that provides helpful information about health, medical conditions, symptoms, treatments, and general wellness
- You can discuss medical topics, explain symptoms, provide general health advice, and suggest when to seek professional medical care
- You should ONLY respond to healthcare and medical-related questions
- If a user asks about non-medical topics, politely redirect them by saying: "I'm a medical assistant focused on healthcare topics. Please ask me about health, medical conditions, symptoms, or wellness concerns."
- Always remind users that your advice is for informational purposes only and cannot replace professional medical diagnosis or treatment
- Encourage users to consult with healthcare professionals for serious concerns or before making medical decisions
- Be empathetic, professional, and supportive in your responses

Please provide helpful, accurate medical information while staying within your scope as a medical assistant.'''
      };

      // Convert provider messages to the required format
      final userMessages = messagesProvider
          .map((e) {
            print('provider ${e.message.content}');
            return {
              'role': e.message.role,
              'content': e.message.content,
            };
          })
          .toList()
          .reversed
          .toList();

      // Combine system message with user messages
      final allMessages = [systemMessage, ...userMessages];

      final request = ChatCompleteText(messages: allMessages, maxToken: 200, model: Gpt4ChatModel());

      openAI!.onChatCompletionSSE(request: request).listen(
        (it) {
          if (it.choices?.isNotEmpty == true) {
            messagesProvider[0].message.content += it.choices?.last.message?.content ?? '';
            setState(() {});
            debugPrint(it.choices?.last.message?.content);
          }
        },
        onError: (error) {
          setState(() {
            errorMessage = 'Failed to get response: ${error.toString()}';
          });
          debugPrint('OpenAI Error: $error');
        },
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Error sending message: ${e.toString()}';
      });
      debugPrint('Chat Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<MessageProvider> messages = Provider.of<MessagesProvider>(context).messages;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        title: const Text(
          'Medical Assistant',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 13.0),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Error message display
          if (errorMessage != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                border: Border.all(color: Colors.red.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: messages[index].message.role == 'user' ? User(message: messages[index].message.content) : Assistant(message: messages[index].message.content),
                );
              },
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextField(
              controller: controller,
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              decoration: InputDecoration(
                // border color
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                hintText: 'Ask me about your health concerns...',
                suffixIcon: InkWell(
                  splashFactory: NoSplash.splashFactory,
                  onTap: openAI == null || controller.text.trim().isEmpty
                      ? null
                      : () {
                          final messageText = controller.text.trim();
                          if (messageText.isNotEmpty && openAI != null) {
                            Provider.of<MessagesProvider>(context, listen: false).addMessage(MessageProvider(message: MessageModel(content: messageText, role: 'user')));
                            Provider.of<MessagesProvider>(context, listen: false).addMessage(MessageProvider(message: MessageModel(content: '', role: 'assistant')));

                            setState(() {
                              controller.clear();
                              errorMessage = null; // Clear any previous errors
                            });
                            chatCompleteWithSSE();
                          }
                        },
                  child: Icon(
                    Icons.send,
                    color: openAI == null || controller.text.trim().isEmpty ? Colors.grey : Colors.red,
                  ),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.red)),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
