import 'package:flutter_miarmapp/models/post_response.dart';

abstract class UserRepository {
  Future<UsuarioDTO> fetchUser();
}
