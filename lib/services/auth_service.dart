
import 'dart:convert';

import 'package:chat/global/environment.dart';
import 'package:chat/models/login_response.dart';
import 'package:chat/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier{

  late User usuario;
  bool _authenticated = false;

  final _storage = const FlutterSecureStorage();

  bool get authenticated => this._authenticated;
  set authenticated(bool value) {
    _authenticated = value;
    notifyListeners();
  }

  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token!;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }
  
  Future<bool> login(String email, String password) async {
    authenticated = true;
    
    final data = {
      'email': email,
      'password': password
    };
    final resp = await http.post(
      Uri.parse('${ Environment.apiUrl }/login'),
      body: jsonEncode(data),
      headers: {
        'Content-type': 'application/json'
      }
    );

    authenticated = false;
    if(resp.statusCode == 200){
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await _saveToken(loginResponse.token);
      return true;
    }else{
      return false;
    }
    
  }

  Future register(String name, String email, String password ) async {
     authenticated = true;
    
    final data = {
      'email': email,
      'password': password,
      'nombre': name
    };
    final resp = await http.post(
      Uri.parse('${ Environment.apiUrl }/login/new'),
      body: jsonEncode(data),
      headers: {'Content-type': 'application/json'}
    );

    authenticated = false;
    if(resp.statusCode == 200){
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await _saveToken(loginResponse.token);
      
      return true;
    }else{
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    
    if(token == null){
      logOut();
      return false;
    }
    
    final resp = await http.get(
        Uri.parse('${Environment.apiUrl}/login/renew'),
        headers: {
          'Content-type': 'application/json',
          'x-token': token!,
        },
    );

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await _saveToken(loginResponse.token);
      return true;
    } else {
      logOut();
      return false;
    }
  
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token); 
  }

  Future logOut() async {
    await _storage.delete(key: 'token');
  }

}