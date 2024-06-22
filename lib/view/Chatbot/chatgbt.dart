import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _userMessageController = TextEditingController();
  List<Map<String, dynamic>> _chatMessages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.android, color: Colors.green),
            SizedBox(width: 8),
            Text('Finance Advisor ChatBot'),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Color(0xFF1E1E1E),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                reverse: true,
                itemCount: _chatMessages.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> message = _chatMessages[index];
                  bool isUserMessage = message['isUserMessage'];

                  return Align(
                    alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: isUserMessage ? Color(0xFF00796B) : Color(0xFF2C2C2E),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0),
                          bottomLeft: isUserMessage ? Radius.circular(12.0) : Radius.circular(0),
                          bottomRight: isUserMessage ? Radius.circular(0) : Radius.circular(12.0),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          if (!isUserMessage) ...[
                            Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Icon(Icons.android, color: Colors.green, size: 20),
                            ),
                          ],
                          Expanded(
                            child: Text(
                              message['message'],
                              style: TextStyle(color: Colors.white),
                              textAlign: isUserMessage ? TextAlign.end : TextAlign.start,
                            ),
                          ),
                          if (isUserMessage) ...[
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.person, color: Colors.white, size: 20),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            buildInputField(context),
          ],
        ),
      ),
    );
  }

  Widget buildInputField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: MediaQuery.of(context).size.height * 0.15,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _userMessageController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Ask about your finances...',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                filled: true,
                fillColor: Color(0xFF2C2C2E),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          ),
          SizedBox(width: 16.0),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF00796B),
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: () {
                if (_userMessageController.text.isNotEmpty) {
                  sendMessage(_userMessageController.text);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void sendMessage(String messageText) {
    setState(() {
      _chatMessages.insert(0, {
        'message': messageText,
        'isUserMessage': true,
      });
      _userMessageController.clear();
    });

    // Simulate a response from the chatbot after a short delay
    simulateChatbotResponse();
  }

  void simulateChatbotResponse() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _chatMessages.insert(0, {
          'message': 'This is a response from the finance advisor bot.',
          'isUserMessage': false,
        });
      });
    });
  }
}
