import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_miarmapp/bloc/public_post/public_post_bloc.dart';
import 'package:flutter_miarmapp/bloc/user_bloc/user_bloc.dart';
import 'package:flutter_miarmapp/constants.dart';
import 'package:flutter_miarmapp/models/post_response.dart';
import 'package:flutter_miarmapp/repository/post_repository/post_repository.dart';
import 'package:flutter_miarmapp/repository/post_repository/post_repository_impl.dart';
import 'package:flutter_miarmapp/repository/user_repository/user_repository.dart';
import 'package:flutter_miarmapp/repository/user_repository/user_repository_impl.dart';

import '../widgets/error_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserRepository userRepository;
  late PostRepository postRepository;

  @override
  void initState() {
    super.initState();
    userRepository = UserRepositoryImpl();
    postRepository = PostRepositoryImpl();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) {
        return UserBloc(userRepository)..add(const FetchUserWithType());
      },
      child: Scaffold(body: _createSeeProfile(context)),
    ));
  }

  Widget _createSeeProfile(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserFetchedError) {
          return ErrorPage(
            message: state.message,
            retry: () {
              context.watch<UserBloc>().add(const FetchUserWithType());
            },
          );
        } else if (state is UserFetched) {
          return _createProfile(context, state.usuarioDTO);
        } else {
          return const Text('Not support');
        }
      },
    );
  }

  Widget _createProfile(BuildContext context, UsuarioDTO usuarioDTO) {
    final contentWidth = MediaQuery.of(context).size.width;
    final contentHeight = MediaQuery.of(context).size.height;

    String imageUrlAvatar =
        usuarioDTO.avatar.replaceAll("http://localhost:8080", Constant.apiUrl);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Row(
                children: [
                  Icon(Icons.lock),
                  SizedBox(width: 4.0),
                  Text(
                    usuarioDTO.nick,
                    style: TextStyle(color: Color.fromARGB(255, 255, 254, 254)),
                  ),
                  SizedBox(width: 12.0),
                  Container(
                    alignment: Alignment.center,
                    width: 35.0,
                    height: 25.0,
                  )
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.add_box_outlined),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.send),
                    )
                  ],
                ))
          ],
        )),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: new CircleAvatar(
                            backgroundImage: NetworkImage(imageUrlAvatar),
                            radius: 55.0,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              usuarioDTO.numeroPublicaciones.toString(),
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              "Posts",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              usuarioDTO.numeroSeguidores.toString(),
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              "Seguidores",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              usuarioDTO.numeroSeguidos.toString(),
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              "Seguidos",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Container(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Pablo Segura Velasco",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0))),
                            Text("Sevilla",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0))),
                          ])),
                  SizedBox(height: 12.0),
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 350.0,
                            height: 35.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(
                                width: 2.0,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            child: Text("Editar Perfil",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0))),
                          ),
                          Icon(Icons.expand_more_outlined,
                              color: Color.fromARGB(255, 0, 0, 0))
                        ]),
                  ),
                  SizedBox(height: 24.0),
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 350.0,
                            height: 35.0,
                            child: Text("Historias Destacadas",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.bold)),
                          ),
                          Icon(Icons.expand_more_outlined,
                              color: Color.fromARGB(255, 0, 0, 0))
                        ]),
                  ),
                  Divider(
                    color: Colors.grey[800],
                    thickness: 2.0,
                  ),
                  SizedBox(height: 12.0),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 200.0,
                          child: Icon(Icons.grid_on_outlined,
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        Container(
                          width: 150.0,
                          child: Icon(Icons.portrait_outlined,
                              color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 60.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createSeePosts(BuildContext context) {
    return BlocBuilder<PostsBloc, PostsState>(
      builder: (context, state) {
        if (state is PostsInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PostFetchError) {
          return ErrorPage(
            message: state.message,
            retry: () {
              context.watch<PostsBloc>().add(const FetchPostWithType());
            },
          );
        } else if (state is PostsFetched) {
          return _createPublicView(context, state.posts);
        } else {
          return const Text('Not support');
        }
      },
    );
  }

  Widget _createPublicView(BuildContext context, List<Post> posts) {
    final contentWidth = MediaQuery.of(context).size.width;
    final contentHeight = MediaQuery.of(context).size.height;

    return ListView(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                'Publicaciones',
                style: TextStyle(
                    color: Colors.black.withOpacity(.8),
                    fontWeight: FontWeight.w600,
                    fontSize: 19),
              ),
            ),
          ],
        ),
        SizedBox(
          height: contentHeight - 170,
          width: contentWidth,
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return _createPublicViewItem(context, posts[index]);
            },
            scrollDirection: Axis.vertical,
            separatorBuilder: (context, index) => VerticalDivider(
              color: Colors.transparent,
              width: contentWidth,
            ),
            itemCount: posts.length,
          ),
        ),
      ],
    );
  }

  Widget _createPublicViewItem(BuildContext context, Post post) {
    final contentWidth = MediaQuery.of(context).size.width;
    final contentHeight = MediaQuery.of(context).size.height;
    String imageUrl = post.ficheroAdjunto
        .replaceAll("http://localhost:8080", Constant.apiUrl);
    String imageUrlAvatar = post.usuario.avatar
        .replaceAll("http://localhost:8080", Constant.apiUrl);

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.withOpacity(.3)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset(imageUrl),
        ],
      ),
    );
  }
}
