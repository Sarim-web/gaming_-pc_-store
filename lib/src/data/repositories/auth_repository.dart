import 'dart:convert';
import 'package:flutter_amazon_clone_bloc/src/data/datasources/api/auth_api.dart';
import 'package:flutter_amazon_clone_bloc/src/data/models/user.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final AuthAPI authApi = AuthAPI();

  Future<User> singUpUser(User inputUser) async {
    try {
      http.Response res = await authApi.signUpUser(inputUser);

      if (res.statusCode == 200) {
        User user = User.fromMap(jsonDecode(res.body));
        return user;
      } else {
        throw jsonDecode(res.body)['msg'];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<User> signInUser(String email, String password) async {
    try {
      final http.Response res = await authApi.signInUser(email, password);

      if (res.statusCode == 200) {
        User user = User.fromMap(jsonDecode(res.body));
        return user;
      } else {
        throw jsonDecode(res.body)['msg'];
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> isTokenValid({required String? token}) async {
    if (token == null || token.trim().isEmpty) {
      return false;
    }

    try {
      final http.Response res = await authApi.isTokenValid(token: token.trim());

      if (res.statusCode != 200) {
        return false;
      }

      final String body = res.body.trim();
      if (body.isEmpty) {
        return false;
      }

      try {
        final dynamic decoded = jsonDecode(body);
        return decoded is bool ? decoded : false;
      } catch (_) {
        return false;
      }
    } catch (_) {
      return false;
    }
  }
}
