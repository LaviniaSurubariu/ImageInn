import 'package:freezed_annotation/freezed_annotation.dart';
import 'unsplash_image.dart';

part 'app_state.freezed.dart';
part 'app_state.g.dart';

@freezed
class AppState with _$AppState {
  const factory AppState({
    @Default(<UnsplashImage>[]) List<UnsplashImage> unsplashImages,
  }) = AppState$;

  factory AppState.fromJson(Map<dynamic, dynamic> json) => _$AppStateFromJson(Map<String, dynamic>.from(json));
}
