import 'dart:developer';

import 'package:redux/redux.dart';
import '../actions/load_items.dart';
import '../models/app_state.dart';
import '../models/unsplash_image.dart';

AppState reducer(AppState state, dynamic action) {
  log('$action');

  return combineReducers<AppState>(<Reducer<AppState>>[
    TypedReducer<AppState, LoadItemsSuccessful>(_loadItemsSuccessful).call,
    TypedReducer<AppState, LoadItemsStart>(_loadItemsStart).call,
    TypedReducer<AppState, LoadItemsError>(_loadItemsError).call,
  ])(state, action);
}

AppState _loadItemsSuccessful(AppState state, LoadItemsSuccessful action) {
  return state.copyWith(
    isLoading: false,
    unsplashImages: <UnsplashImage>[...state.unsplashImages, ...action.unsplashImages],
  );
}

AppState _loadItemsStart(AppState state, LoadItemsStart action) {
  return state.copyWith(isLoading: true);
}

AppState _loadItemsError(AppState state, LoadItemsError action) {
  return state.copyWith(isLoading: false);
}
