// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unsplash_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UnsplashImage$Impl _$$UnsplashImage$ImplFromJson(Map<String, dynamic> json) => _$UnsplashImage$Impl(
      description: json['alt_description'] as String,
      smallImage: ImageUrls.fromJson(json['urls'] as Map<String, dynamic>),
      likes: json['likes'] as int,
      authorPage: AuthorUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UnsplashImage$ImplToJson(_$UnsplashImage$Impl instance) => <String, dynamic>{
      'alt_description': instance.description,
      'urls': instance.smallImage,
      'likes': instance.likes,
      'user': instance.authorPage,
    };
