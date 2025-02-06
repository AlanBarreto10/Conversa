import 'dart:convert';

import 'package:chat/models/user.dart';

UsersResponse UsersResponseFromJson(String str) => UsersResponse.fromJson(json.decode(str));

String UsersResponseToJson(UsersResponse data) => json.encode(data.toJson());

class UsersResponse {
    UsersResponse({
        required this.ok,
        required this.usuarios,
    });

    bool ok;
    List<User> usuarios;

    factory UsersResponse.fromJson(Map<String, dynamic> json) => UsersResponse(
        ok: json["ok"],
        usuarios: List<User>.from(json["usuarios"].map((x) => User.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toJson())),
    };
}