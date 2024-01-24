import 'dart:convert';

import 'package:http/http.dart';
import '../models/unsplash_image.dart';

class ImageApi {
  ImageApi(this._accessKey, this._client);

  final String _accessKey;
  final Client _client;

  Future<List<UnsplashImage>> loadItems(int page, String query, String color, {bool isSearching = false}) async {
    final Response response;
    final List<dynamic> imgData;

    if (query.isNotEmpty) {
      final Uri uri = Uri.parse('https://api.unsplash.com/search/photos/');
      response = await _client.get(
        uri.replace(
          queryParameters: <String, String>{
            'page': '$page',
            if (query.isNotEmpty) 'query': query,
            if (query.isNotEmpty && color.isNotEmpty) 'color': color,
          },
        ),
        headers: <String, String>{'Authorization': 'Client-ID $_accessKey'},
      );

      final Map<String, dynamic> jsonBody = json.decode(response.body) as Map<String, dynamic>;
      imgData = jsonBody['results'] as List<dynamic>;
    } else {
      final Uri uri = Uri.parse('https://api.unsplash.com/photos/');
      response = await _client.get(
        uri.replace(
          queryParameters: <String, String>{
            'page': '$page',
          },
        ),
        headers: <String, String>{'Authorization': 'Client-ID $_accessKey'},
      );

      imgData = json.decode(response.body) as List<dynamic>;
    }

    return imgData.map((dynamic item) => UnsplashImage.fromJson(item as Map<String, dynamic>)).toList();
  }
}
