import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatroom',
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final List<String> _messages = [];
  Socket? _socket;
  bool _usernameSet = false;

  @override
  void initState() {
    super.initState();
    _connectToServer();
  }

  Future<void> _connectToServer() async {
    try {
      _socket = await Socket.connect("localhost", 3000);
      print('Connesso a ${_socket!.remoteAddress.address}:${_socket!.remotePort}');

      _socket!.listen(
        (data) {
          String message = utf8.decode(data).trim();
          setState(() {
            _messages.add(message);
          });
        },
        onDone: () {
          setState(() {
            _messages.add('Server disconnesso');
          });
        },
        onError: (error) {
          setState(() {
            _messages.add('Errore ricezione: $error');
          });
        },
      );
    } catch (e) {
      setState(() {
        _messages.add('Errore: $e');
      });
    }
  }

  void _sendMessage() async {
    String message = _inputController.text.trim();

    if (message.isEmpty || _socket == null) return;

    if (message.toLowerCase() == 'exit1') {
      await _socket!.close();
      return;
    }

    _socket!.write('$message\n');
    await _socket!.flush();

    if (!_usernameSet) {
      _usernameSet = true;
    }

    _inputController.clear();
  }

  @override
  void dispose() {
    _socket?.close();
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatroom'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(_messages[index]),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: InputDecoration(
                      hintText: _usernameSet ? 'Scrivi un messaggio' : 'Inserisci nome utente',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}