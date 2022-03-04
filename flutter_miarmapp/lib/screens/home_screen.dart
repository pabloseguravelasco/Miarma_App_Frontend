import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_miarmapp/bloc/public_post/public_post_bloc.dart';
import 'package:flutter_miarmapp/constants.dart';
import 'package:flutter_miarmapp/widgets/home_app_bar.dart';
import 'package:insta_like_button/insta_like_button.dart';

import '../models/post_response.dart';
import '../repository/post_repository/post_repository.dart';
import '../repository/post_repository/post_repository_impl.dart';
import '../widgets/error_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PostRepository postRepository;

  @override
  void initState() {
    super.initState();
    postRepository = PostRepositoryImpl();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: ListView(children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Historias',
                style: TextStyle(
                    color: Colors.black.withOpacity(.8),
                    fontWeight: FontWeight.w600,
                    fontSize: 19),
              ),
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.arrow_right,
                    size: 43,
                  ),
                  Text(
                    'Ver Todas',
                    style: TextStyle(
                        color: Colors.black.withOpacity(.8),
                        fontWeight: FontWeight.w600,
                        fontSize: 19),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 15),
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          width: 75,
                          height: 75,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage('assets/images/avatar.jpg'),
                                  fit: BoxFit.cover)),
                        ),
                        Positioned(
                          bottom: 0,
                          right: -1,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white)),
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Mi Historia',
                      style: TextStyle(
                          color: Colors.black.withOpacity(.8),
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
              story(
                'assets/images/avatar.jpg',
                'Bojji',
              ),
              story(
                'assets/images/avatar.jpg',
                'Bojji',
              ),
              story('assets/images/avatar.jpg', 'Bojji'),
              story('assets/images/avatar.jpg', 'Bojji'),
              story('assets/images/avatar.jpg', 'Bojji'),
            ],
          ),
        ),
        SizedBox(
            width: 800,
            height: 800,
            child: BlocProvider(
              create: (context) {
                return PostsBloc(postRepository)
                  ..add(const FetchPostWithType());
              },
              child: Scaffold(body: _createSeePosts(context)),
            )),
      ]),
    );
  }
}

Widget story(String image, name) {
  return Padding(
    padding: const EdgeInsets.only(right: 12),
    child: Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(0.1),
          width: 76,
          height: 76,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Color.fromARGB(213, 194, 24, 132), width: 3)),
          child: ClipOval(
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          name,
          style: TextStyle(
              color: Colors.black.withOpacity(.8), fontWeight: FontWeight.w500),
        )
      ],
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
  String imageUrl =
      post.ficheroAdjunto.replaceAll("http://localhost:8080", Constant.apiUrl);
  String imageUrlAvatar =
      post.usuario.avatar.replaceAll("http://localhost:8080", Constant.apiUrl);

  return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(.3)))),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(imageUrlAvatar),
            ),
            title: Text(
              post.usuario.nick,
              style: TextStyle(
                  color: Colors.black.withOpacity(.8),
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
            trailing: const Icon(Icons.more_vert),
          ),
        ),
        InstaLikeButton(
          image: NetworkImage(
            imageUrl,
          ),
          width: double.infinity,
          onChanged: () {},
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: const <Widget>[
                  Icon(Icons.favorite_border, size: 31),
                  SizedBox(
                    width: 12,
                  ),
                  Icon(Icons.comment_sharp, size: 31),
                  SizedBox(
                    width: 12,
                  ),
                  Icon(Icons.send, size: 31),
                ],
              ),
              const Icon(Icons.bookmark_border, size: 31)
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: Text(
            'Les ha gustado esta publicación',
            style: TextStyle(fontSize: 16, color: Colors.black.withOpacity(.8)),
          ),
        )
      ],
    ),
  );
}
