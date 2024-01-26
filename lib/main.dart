import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';

import 'firebase_options.dart';
import 'src/api/auth_api.dart';
import 'src/api/image_api.dart';
import 'src/epics/app_epics.dart';
import 'src/models/app_state.dart';
import 'src/presentation/create_user.dart';
import 'src/presentation/home_page.dart';
import 'src/reducer/reducer.dart';

Future<dynamic> main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  final Client client = Client();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final FirebaseAuth auth = FirebaseAuth.instance;
  final ImageApi api = ImageApi(dotenv.env['API_KEY']!, client);
  final AuthApi authApi = AuthApi(auth: auth);
  final AppEpics appEpic = AppEpics(api, authApi);

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
        routes: <String, WidgetBuilder>{
          '/createUser': (BuildContext context) => const CreateUserPage(),
        },
      ),
    );
  }
}
