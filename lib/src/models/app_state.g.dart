// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppState$Impl _$$AppState$ImplFromJson(Map<String, dynamic> json) =>
    _$AppState$Impl(
      unsplashImages: (json['unsplashImages'] as List<dynamic>?)
              ?.map((e) => UnsplashImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <UnsplashImage>[],
      isLoading: json['isLoading'] as bool? ?? false,
      page: json['page'] as int? ?? 1,
      query: json['query'] as String? ?? '',
      color: json['color'] as String? ?? '',
    );

Map<String, dynamic> _$$AppState$ImplToJson(_$AppState$Impl instance) =>
    <String, dynamic>{
      'unsplashImages': instance.unsplashImages,
      'isLoading': instance.isLoading,
      'page': instance.page,
      'query': instance.query,
      'color': instance.color,
    };
