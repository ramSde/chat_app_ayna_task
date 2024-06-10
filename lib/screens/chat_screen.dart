import 'package:chat_app_ayna/constats.dart';
import 'package:chat_app_ayna/services/web_socket_services.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final WebSocketService _webSocketService = WebSocketService();
  late Future<Box> _chatBoxFuture;
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _chatBoxFuture = _initHive();
    _webSocketService.connect();
    _webSocketService.messages.listen((message) {
      setState(() {
        final receivedMessage = {
          "isMine": false,
          "message": message,
          "timestamp": DateTime.now().toIso8601String(),
        };
        _messages.add(receivedMessage);
        _saveMessage(receivedMessage);
      });
    });
  }

  Future<Box> _initHive() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    final chatBox = await Hive.openBox('chatBox');
    _loadMessages();
    return chatBox;
  }

  void _loadMessages() async {
  final boxofchat = await Hive.openBox('chatBox');
  var messages = boxofchat.values.toList();
  List<Map<String, dynamic>> formattedMessages = [];
  messages.forEach((dynamic message) {
    formattedMessages.add(Map<String, dynamic>.from(message));
  });
  print("message================$formattedMessages");
  setState(() {
    _messages = formattedMessages;
  });
}


  void _sendMessage() {
    final message = _messageController.text;
    if (message.isNotEmpty) {
      final sentMessage = {
        "isMine": true,
        "message": message,
        "timestamp": DateTime.now().toIso8601String(),
      };
      setState(() {
        _messages.add(sentMessage);
        _saveMessage(sentMessage);
      });
      _webSocketService.sendMessage(message);
      _messageController.clear();
    }
  }

  Future<void> _saveMessage(Map<String, dynamic> message) async {
    final chatBox = await Hive.openBox('chatBox');
    chatBox.add(message);
  }

  @override
  void dispose() {
    _webSocketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Chat with Server'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async{
             await userrepo.logOut(context);
            },
          ),
        ]
      ),
      body: FutureBuilder(
        future: _chatBoxFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final timestamp = DateTime.parse(message['timestamp']);
                      final formattedTime =
                          "${timestamp.hour}:${timestamp.minute}";
                      return Align(
                        alignment: message['isMine']
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color:
                                message['isMine'] ? Colors.blue : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['message'],
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 5),
                              Text(
                                formattedTime,
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Enter your message',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
