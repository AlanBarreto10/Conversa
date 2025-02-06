import 'package:chat/global/environment.dart';
import 'package:chat/models/messages_response.dart';
import 'package:chat/models/user.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {

  User? userTo;
  
  Future<List<Mensaje>> getChat( String usuarioID ) async {

    
    final resp = await http.get(
      Uri.parse('${ Environment.apiUrl }/mensajes/$usuarioID'),
      headers: {
        'Content-type': 'application/json',
        'x-token': await AuthService.getToken()
      }
    );

    final mensajesResp = mensajesResponseFromJson(resp.body);

    return mensajesResp.mensajes;


  }

}