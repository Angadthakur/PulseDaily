import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/article_model.dart';
import 'package:news_app/utils/api_constants.dart';


class BookmarkProvider extends ChangeNotifier {
  List<Article> _bookmarks = [];
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isLoading = false;


  List<Article> get bookmarks => _bookmarks;
  bool get isLoading => _isLoading;

  BookmarkProvider(){
    fetchBookmarks();
  }


//bookmarks from backend
  Future<void> fetchBookmarks() async {
    try{
      _isLoading =  true;
      notifyListeners();

      final token = await _storage.read(key: 'jwt_token');
      if (token == null) return;

      final response = await http.get(
        Uri.parse(ApiConstants.bookmarksEndpoint),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200){
        final List<dynamic> jsonList =  jsonDecode(response.body);
        _bookmarks =  jsonList.map((json) => Article.fromJson(json)).toList();
      }
    } catch(e){
      print("Error fetching bookmarks: $e");
    } finally {
      _isLoading =  false;
      notifyListeners();
    }
  }
  
  //if bookmarked
  bool isBookmarked(Article article) {
    return _bookmarks.any((b) => b.url == article.url);
  }

  //add or remove bookmark
  Future<void> toggleBookmark(Article article) async {
    final token = await _storage.read(key: 'jwt_token');
    if(token == null) return;

    final currentlyBookmarked = isBookmarked(article);

    if(currentlyBookmarked){
      _bookmarks.removeWhere((b) => b.url == article.url);
    }else {
      _bookmarks.add(article);
    }
    notifyListeners();

    try{
      if(currentlyBookmarked){
        await http.delete(
          Uri.parse('${ApiConstants.bookmarksEndpoint}'),
          headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
          body: jsonEncode({'url' : article.url})
        );
      }else{
        await http.post(
          Uri.parse(ApiConstants.bookmarksEndpoint),
          headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
          body: jsonEncode({
            "title": article.title,
            "description": article.description ?? "",
            "url": article.url,
            "urlToImage": article.urlToImage ?? "",
            "sourceName": article.author ?? "", // Mapping author for now
            "publishedAt": article.publishedAt,
          }),
        );
      }
    }catch(e){
      print("Error toggling bookmark: $e");
      fetchBookmarks();
    }
  }

}