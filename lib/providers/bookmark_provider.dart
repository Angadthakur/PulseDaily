import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkProvider extends ChangeNotifier {
  List<Article> _bookmarks = [];
  late SharedPreferences _prefs;

  List<Article> get bookmarks => _bookmarks;

  BookmarkProvider(){
    _initPref();
  }


//initialize SharedPreferences and load bookmarks
  Future<void> _initPref() async {
    _prefs = await SharedPreferences.getInstance();
    _loadBookmarks();
  }
  
  //load bookmarks from local storage
  void _loadBookmarks (){
    final List<String>? bookmarksJson = _prefs.getStringList("bookmakrs");
    if(bookmarksJson != null){
      _bookmarks = bookmarksJson
      .map((jsonString)=> Article.fromJson(jsonDecode(jsonString)))
      .toList();

      notifyListeners();
    }
  }

  //save bookmarks to local storage
  Future<void> _saveBookmarks() async{
    final List<String> bookmarksJson = _bookmarks
    .map((article)=> jsonEncode({
      "title":article.title,
      'description': article.description,
              'urlToImage': article.urlToImage,
              'url': article.url,
              'author': article.author,
              'publishedAt': article.publishedAt,
              'content': article.content,
    }))
    .toList();
    await _prefs.setStringList("bookmakrs", bookmarksJson);
  }
  
  //check if an article is bookmarked already
  bool isBookmarked (Article article){
    return _bookmarks.any((b)=> b.url == article.url);
  }

  //add or remove a bookmark
  void toggleBookmark(Article article) {
    if (isBookmarked(article)) {
      _bookmarks.removeWhere((b) => b.url == article.url);
    } else {
      _bookmarks.add(article);
    }
    _saveBookmarks();
    notifyListeners();

}
}