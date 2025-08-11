import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:news_app/models/article_model.dart';

class NewsService {
  final String _apiKey = "80b5ee0e48fa4bc98e1801e733e32beb";
  final String _baseUrl = "https://newsapi.org/v2";

  final List<String> _globalCountryCodes = ["in","us","gb","au","ca"];

  Future<List<Article>> fetchNews(String category) async{

    List<Future<List<Article>>> futures =[];

    for(String countryCode in _globalCountryCodes){
      futures.add(_fetchTopHeadLinesForCountry(category,countryCode));

    }
    try{
      final List<List<Article>> results =  await Future.wait(futures);

      final List<Article> allArticles =  results.expand((list)=> list).toList();

      allArticles.shuffle(Random());
      return allArticles;
    } catch (e){
      print("Error fetching global news: $e");
      throw Exception("Failed to fetch global news");
    }
  }

  Future<List<Article>> _fetchTopHeadLinesForCountry(String category, String countryCode) async{
    String url;
    if(category.toLowerCase() == "top news"){
      url = "$_baseUrl/top-headlines?country=$countryCode&apiKey=$_apiKey";
    }else{
      url = '$_baseUrl/top-headlines?country=$countryCode&category=$category&apiKey=$_apiKey';
    }
    return _fetchArticlesFromUrl(url);
  }

  Future<List<Article>> _fetchKeywordNews(String keyword) async {
    final url = '$_baseUrl/everything?q=$keyword&language=en&sortBy=popularity&apiKey=$_apiKey';
    return _fetchArticlesFromUrl(url);
  }

  Future<List<Article>> _fetchArticlesFromUrl(String url) async {
    try{
      final response = await http.get(Uri.parse(url));

      if(response.statusCode == 200){
        final Map<String,dynamic> json = jsonDecode(response.body);
        final List<dynamic> articlesJson = json['articles'] ?? [];

        return articlesJson
        .map((json)=>Article.fromJson(json))
        .where((article)=> article.url.isNotEmpty)
        .toList();

        
      }else{
        //if one country fails, returns an empty list , prevents from app crashing
        throw Exception ("Failed to load news from $url: ${response.statusCode}");
        return [];
      }
    }catch (e){
      print("Exception for $url:$e");
      return [];

    }
  }
}
