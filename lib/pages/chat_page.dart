import 'dart:io';

import 'package:chat/widgets/chat_message.dart';
import 'package:chat/models/messages_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;
  List<ChatMessage> _messages = [];

  bool _estaEscribiendo = false;

  @override
  void initState() {
    super.initState();
    chatService   = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService   = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket?.on('mensaje-personal', _listenMessage );

    _loadHistorial( chatService.userTo!.uid );
  }

  void _loadHistorial( String usuarioID ) async {

    List<Mensaje> chat = await this.chatService.getChat(usuarioID);

    final history = chat.map((m) => new ChatMessage(
      texto: m.mensaje,
      uid: m.de,
      animationController: new AnimationController(vsync: this, duration: Duration( milliseconds: 0))..forward(),
    ));

    setState(() {
      _messages.insertAll(0, history);
    });

  }

  void _listenMessage( dynamic payload ) {
    
    ChatMessage message = new ChatMessage(
      texto: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController( vsync: this, duration: Duration(milliseconds: 300 )),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();

  }
 
  @override
  Widget build(BuildContext context) {
    final userTo = chatService.userTo;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white24,
        title: Column(
          children: [
            CircleAvatar(
              child: Text('Te', style: TextStyle(fontSize: 12),),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height: 4,),
            Text(userTo!.nombre , style: TextStyle(color: Colors.black87, fontSize: 12),)
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (_,i) => _messages[i],
                itemCount: _messages.length,
                reverse: true,
              )
            ),
            Divider(height: 1,),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat(){
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmit,
              onChanged: (String texto){
                setState(() {
                  if(texto.trim().length > 0){
                    _estaEscribiendo = true;
                  }else{
                    _estaEscribiendo = false;
                  }
                });
              },
              decoration: const InputDecoration.collapsed(hintText: 'Enviar mensaje'),
              focusNode: _focusNode,
              )
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
              ? CupertinoButton(
                child: Text('Enviar'), 
                onPressed: _estaEscribiendo 
                  ? () => _handleSubmit(_textController.text.trim())
                  : null,
              )
              : Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: IconTheme(
                  data: IconThemeData( color: Colors.blue[400]),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: _estaEscribiendo 
                    ? () => _handleSubmit(_textController.text.trim())
                    : null,
                    icon: const Icon(Icons.add)
                  ),
                ),
              )
            )
          ],
        )
      )
    );
  }

  _handleSubmit(String texto){
    if(texto.length == 0) return;

    print(texto);
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = new ChatMessage(
      texto: authService.usuario.uid, 
      uid: texto,
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200))
      );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _estaEscribiendo = false;
    });

    socketService.emit!('mensaje-personal', {
      'de': authService.usuario.uid,
      'para': chatService.userTo?.uid,
      'mensaje': texto
    });

    
  }

  @override
  void dispose() {
    // TODO: off del socket
    for(ChatMessage message in _messages){
      message.animationController.dispose();
    }
    socketService.socket?.off('mensaje-personal');
    super.dispose();
  }
}