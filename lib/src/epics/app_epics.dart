import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

import '../actions/load_items.dart';
import '../api/image_api.dart';
import '../models/app_state.dart';
import '../models/unsplash_image.dart';

class AppEpics extends EpicClass<AppState> {
  AppEpics(this.api);

  final ImageApi api;

  @override
  Stream<dynamic> call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return combineEpics(<Epic<AppState>>[TypedEpic<AppState, LoadItemsStart>(_loadItemsStart).call])(actions, store);
  }

  Stream<dynamic> _loadItemsStart(Stream<LoadItemsStart> actions, EpicStore<AppState> store) {
    return actions
        .debounceTime(const Duration(milliseconds: 500))
        .asyncMap((LoadItemsStart action) {
          return api.loadItems(store.state.page, query: store.state.query, color: action.color);
        })
        .map((List<UnsplashImage> unsplashImages) => LoadItems.successful(unsplashImages))
        .onErrorReturnWith((Object error, StackTrace stackTrace) => LoadItems.error(error, stackTrace));
  }
}
