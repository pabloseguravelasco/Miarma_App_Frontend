import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/post_response.dart';
import '../../repository/post_repository/post_repository.dart';

part 'public_post_event.dart';
part 'public_post_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final PostRepository postRepository;

  PostsBloc(this.postRepository) : super(PostsInitial()) {
    on<FetchPostWithType>(_postsFetched);
  }

  void _postsFetched(FetchPostWithType event, Emitter<PostsState> emit) async {
    try {
      final posts = await postRepository.fetchPosts();
      emit(PostsFetched(posts));
      return;
    } on Exception catch (e) {
      emit(PostFetchError(e.toString()));
    }
  }
}
