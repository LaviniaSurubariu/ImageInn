import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';

import 'src/api/image_api.dart';
import 'src/epics/app_epics.dart';
import 'src/models/app_state.dart';
import 'src/presentation/home_page.dart';
import 'src/reducer/reducer.dart';

Future<dynamic> main() async {
  await dotenv.load();

  final Client client = Client();
  final ImageApi api = ImageApi(dotenv.env['API_KEY']!, client);
  final AppEpics appEpic = AppEpics(api);

  final Store<AppState> store =
      Store<AppState>(reducer, initialState: const AppState(), middleware: <Middleware<AppState>>[
    EpicMiddleware<AppState>(appEpic.call).call,
  ]);

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.store});

  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
        home: const HomePage(),
      ),
    );
  }
}
