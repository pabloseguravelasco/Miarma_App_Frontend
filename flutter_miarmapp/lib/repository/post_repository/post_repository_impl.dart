import 'dart:io';

import 'package:http/http.dart';
import 'dart:convert';

import 'package:flutter_miarmapp/repository/post_repository/post_repository.dart';

import '../../models/post_response.dart';
import '../../constants.dart';

class PostRepositoryImpl extends PostRepository {
  final Client _client = Client();

  @override
  Future<List<Post>> fetchPosts() async {
    String token = Constant.token;
    final response = await _client
        .get(Uri.parse('${Constant.apiUrl}/post/public'), headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $token"
    });
    if (response.statusCode == 200) {
      return PostsResponse.fromJson(json.decode(response.body)).content;
    } else {
      throw Exception('Fail to load posts');
    }
  }
}
