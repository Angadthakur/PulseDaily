import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/services/news_service.dart';

class NewsProvider extends ChangeNotifier {
  final NewsService _newsService = NewsService();

  final Map<String,List<Article>> _articlesByCategory = {};

  final Map<String,bool> _isLoadingByCategory = {};

  String? _errorMessage;

  List<Article> getArticlesForCategory(String category) => _articlesByCategory[category] ?? [];
  bool isLoadingForCategory(String category) => _isLoadingByCategory[category] ?? false;
  String? get errorMessage => _errorMessage;

  Future<void> fetchNews(String category) async{
   if(_isLoadingByCategory[category]== true) return;

   _isLoadingByCategory[category] = true;
   _errorMessage =  null;
   notifyListeners();

   try{
    final articles = await _newsService.fetchNews(category);
    _articlesByCategory[category] =  articles;
   }catch (e){
    _errorMessage =  e.toString();
   }finally{
    _isLoadingByCategory[category] = false;
    notifyListeners();
   }
  }
}