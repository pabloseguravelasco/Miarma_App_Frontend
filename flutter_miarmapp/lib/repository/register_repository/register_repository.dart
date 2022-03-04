import 'package:flutter_miarmapp/models/register_dto.dart';
import 'package:flutter_miarmapp/models/register_response.dart';

abstract class RegisterRepository {

   Future<RegisterResponse> register(RegisterDto registerDto, String filePath);

}