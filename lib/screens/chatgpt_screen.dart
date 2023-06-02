import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:health_care/models/message_model.dart';
import 'package:health_care/widgets/chatgpt_widget.dart';
import 'package:provider/provider.dart';

import '../providers/message_provider.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});
  static const routeName = 'chat';

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final openAI = OpenAI.instance.build(token: 'YOUR_API_KEY_HERE', baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)), enableLog: true);
  TextEditingController controller = TextEditingController();

  void chatCompleteWithSSE() {
    List<MessageProvider> messagesProvider = Provider.of<MessagesProvider>(context, listen: false).messages;
    final request = ChatCompleteText(messages: [
      Map.of(
        messagesProvider[1].message.toJson(),
      )
    ], maxToken: 30, model: ChatModel.gptTurbo);

    openAI.onChatCompletionSSE(request: request).listen((it) {
      messagesProvider[0].message.content += it.choices.last.message?.content ?? '';
      setState(() {});
      debugPrint(it.choices.last.message?.content);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<MessageProvider> messages = Provider.of<MessagesProvider>(context).messages;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text('Assistant'),
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
                  print('tap outside');
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  hintText: 'Ask me something',
                  suffixIcon: InkWell(
                    splashFactory: NoSplash.splashFactory,
                    onTap: () {
                      chatCompleteWithSSE();
                      print('send');
                      Provider.of<MessagesProvider>(context, listen: false).addMessage(MessageProvider(message: MessageModel(content: controller.text, role: 'user')));
                      // FocusManager.instance.primaryFocus?.unfocus();
                      setState(() {
                        controller.clear();
                      });
                      Provider.of<MessagesProvider>(context, listen: false).addMessage(MessageProvider(message: MessageModel(content: '', role: 'assistant')));
                    },
                    child: const Icon(Icons.send),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
