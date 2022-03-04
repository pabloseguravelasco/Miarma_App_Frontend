import 'dart:convert';


import 'package:flutter_miarmapp/constants.dart';
import 'package:flutter_miarmapp/models/login_dto.dart';
import 'package:flutter_miarmapp/models/login_response.dart';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_repository.dart';


class AuthRepositoryImpl extends AuthRepository {
  final Client _client = Client();

  @override
  Future<LoginResponse> login(LoginDto loginDto) async {
    final prefs = await SharedPreferences.getInstance();
    final response =
        await _client.post(Uri.parse("${Constant.apiUrl}/auth/login"),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(loginDto.toJson()));
    if (response.statusCode == 201) {
      prefs.setString(
          'token', LoginResponse.fromJson(json.decode(response.body)).token);
      prefs.setString(
          'avatar', LoginResponse.fromJson(json.decode(response.body)).avatar);
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Fail to login');
    }
  }}


