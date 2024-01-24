import 'dart:developer';

import 'package:redux/redux.dart';
import '../actions/load_items.dart';
import '../models/app_state.dart';
import '../models/unsplash_image.dart';

AppState reducer(AppState state, dynamic action) {
  log('$action');

  return combineReducers<AppState>(
      <Reducer<AppState>>[TypedReducer<AppState, LoadItemsSuccessful>(_loadItemsSuccessful).call])(state, action);
}

AppState _loadItemsSuccessful(AppState state, LoadItemsSuccessful action) {
  return state.copyWith(unsplashImages: <UnsplashImage>[...state.unsplashImages, ...action.unsplashImages]);
}
