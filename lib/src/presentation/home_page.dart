import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../actions/get_comments.dart';
import '../actions/load_items.dart';
import '../actions/set.dart';
import '../models/app_state.dart';
import '../models/app_user.dart';
import '../models/unsplash_image.dart';
import 'containers/app_user_container.dart';
import 'containers/images_container.dart';
import 'containers/is_loading_container.dart';
import 'extensions.dart';
import 'user_picture.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController controller = ScrollController();
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.dispatch(const LoadItems());
    controller.addListener(_onScroll);
  }

  Future<void> followlink(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _onScroll() {
    final double offset = controller.offset;
    final double maxExtend = controller.position.maxScrollExtent;

    if (!context.state.isLoading && offset > maxExtend * 0.8) {
      context.dispatch(const LoadItems());
    }
  }

  @override
  void dispose() {
    controller.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ImagesContainer(
      builder: (BuildContext context, List<UnsplashImage> images) {
        return IsLoadingContainer(
          builder: (BuildContext context, bool isLoading) {
            return RefreshIndicator(
              onRefresh: () async {
                textController.clear();
                context
                  ..dispatch(const SetQuery(''))
                  ..dispatch(const SetColor(''))
                  ..dispatch(const LoadItems());

                await context.store.onChange.firstWhere((AppState state) => !state.isLoading);
              },
              child: AppUserContainer(
                builder: (BuildContext context, AppUser? user) {
                  return Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      backgroundColor: Colors.blue,
                      title: const Text('ImageInn'),
                      titleTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                      actions: <Widget>[
                        if (user != null)
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/profile');
                            },
                            child: const UserPicture(),
                          ),
                      ],
                    ),
                    body: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            decoration: const InputDecoration(hintText: 'search'),
                            controller: textController,
                            onChanged: (String value) {
                              context.dispatch(SetQuery(value));
                              if (context.state.query.isEmpty) {
                                context.dispatch(const SetColor(''));
                              }
                              context.dispatch(const LoadItems());
                            },
                          ),
                        ),
                        Wrap(
                          children: allColors.map(
                            (String item) {
                              return ChoiceChip(
                                label: Text(item),
                                selected: context.state.color == item || false,
                                onSelected: (bool selected) {
                                  if (context.state.query.isNotEmpty) {
                                    context.dispatch(SetColor(selected ? item : ''));
                                  }
                                  context.dispatch(const LoadItems());
                                },
                              );
                            },
                          ).toList(),
                        ),
                        Expanded(
                          child: CustomScrollView(
                            controller: controller,
                            slivers: <Widget>[
                              if (!isLoading && images.isEmpty)
                                const SliverToBoxAdapter(
                                  child: Center(
                                    child: Text('No items found'),
                                  ),
                                ),
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    final UnsplashImage unsplashImage = images[index];

                                    return GestureDetector(
                                      onTap: () {
                                        if (user != null) {
                                          context
                                            ..dispatch(SetSelectedImage(unsplashImage))
                                            ..dispatch(GetComments(unsplashImage.imageId));
                                          Navigator.pushNamed(context, '/image');
                                        } else {
                                          Navigator.pushNamed(context, '/createUser');
                                        }
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 300,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                const Expanded(
                                                  child: SizedBox(
                                                    height: 200,
                                                    child: Column(),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 300,
                                                  height: 300,
                                                  child: Image.network(
                                                    unsplashImage.smallImage.thumb,
                                                    fit: BoxFit.cover,
                                                    alignment: Alignment.bottomRight,
                                                    loadingBuilder: (BuildContext context, Widget widget,
                                                        ImageChunkEvent? progress) {
                                                      if (progress == null) {
                                                        return widget;
                                                      }
                                                      return SizedBox(
                                                        height: 300,
                                                        child: Center(
                                                          child: CircularProgressIndicator(
                                                            value: progress.cumulativeBytesLoaded /
                                                                (progress.expectedTotalBytes ?? 1),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                const Spacer(),
                                              ],
                                            ),
                                          ),
                                          ListTile(
                                            title: Text(
                                              unsplashImage.description ?? 'No description',
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: TextButton(
                                                onPressed: () {
                                                  followlink(Uri.parse(unsplashImage.authorPage.links.html));
                                                },
                                                child: Text(unsplashImage.authorPage.links.html)),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  childCount: images.length,
                                ),
                              ),
                              if (isLoading)
                                SliverToBoxAdapter(
                                  child: Padding(
                                    padding: MediaQuery.paddingOf(context),
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

final List<String> allColors = <String>[
  'black_and_white',
  'black',
  'white',
  'yellow',
  'orange',
  'red',
  'purple',
  'magenta',
  'green',
  'teal',
  'blue'
];
