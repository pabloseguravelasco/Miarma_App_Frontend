part of 'public_post_bloc.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

class FetchPostWithType extends PostsEvent {
  const FetchPostWithType();

  @override
  List<Object> get props => [];
}
