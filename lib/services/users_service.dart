import 'package:chat/global/environment.dart';
import 'package:chat/models/user.dart';
import 'package:chat/models/users_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:http/http.dart' as http;

class UsuariosService {

  Future<List<User>> getUsuarios() async {

    try {
      
      final resp = await http.get(
      Uri.parse('${ Environment.apiUrl }/users'),
      headers: {
        'Content-type': 'application/json',
        'x-token': await AuthService.getToken()
      }
    );

      final usuariosResponse = UsersResponseFromJson( resp.body );

      return usuariosResponse.usuarios;

    } catch (e) {
      return [];
    }

  }


}