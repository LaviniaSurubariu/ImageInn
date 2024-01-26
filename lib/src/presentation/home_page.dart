import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../actions/load_items.dart';
import '../models/unsplash_image.dart';
import 'containers/images_container.dart';
import 'containers/is_loading_container.dart';
import 'extensions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController controller = ScrollController();

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
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Colors.blue,
                title: const Text('Unsplash Images'),
                titleTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              body: Column(
                children: <Widget>[
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

                              return Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 300,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: SizedBox(
                                            height: 200,
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue[50],
                                                    borderRadius: BorderRadius.circular(16),
                                                  ),
                                                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                                  child: Text('${unsplashImage.likes}'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 300,
                                          height: 300,
                                          child: Image.network(
                                            unsplashImage.smallImage.thumb,
                                            fit: BoxFit.cover,
                                            alignment: Alignment.bottomRight,
                                            loadingBuilder:
                                                (BuildContext context, Widget widget, ImageChunkEvent? progress) {
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
                                      unsplashImage.description,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: TextButton(
                                        onPressed: () {
                                          followlink(Uri.parse(unsplashImage.authorPage.links.html));
                                        },
                                        child: Text(unsplashImage.authorPage.links.html)),
                                  ),
                                ],
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
        );
      },
    );
  }
}
