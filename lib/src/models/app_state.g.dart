// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppState$Impl _$$AppState$ImplFromJson(Map<String, dynamic> json) => _$AppState$Impl(
      unsplashImages: (json['unsplashImages'] as List<dynamic>?)
              // ignore: always_specify_types
              ?.map((e) => UnsplashImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <UnsplashImage>[],
    );

Map<String, dynamic> _$$AppState$ImplToJson(_$AppState$Impl instance) => <String, dynamic>{
      'unsplashImages': instance.unsplashImages,
    };
