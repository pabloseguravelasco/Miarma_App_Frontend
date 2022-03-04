import '../../models/post_response.dart';

abstract class PostRepository {
  
  Future<List<Post>> fetchPosts();
}
