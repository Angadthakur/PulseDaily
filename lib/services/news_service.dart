import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:news_app/models/article_model.dart';
import 'package:news_app/utils/api_constants.dart'; 

class NewsService {
  Future<List<Article>> fetchNews(String category) async {
    try{
      final String url = '${ApiConstants.newsEndpoint}?category=$category';

      final response = await http.get(Uri.parse(url));
      
      //process the results
      if(response.statusCode == 200){
        final Map<String, dynamic> json =  jsonDecode(response.body);
        final List<dynamic> articlesJson =  json['articles'] ?? [];

        return articlesJson  
               .map((json)=> Article.fromJson(json))
               .where((article) => article.url.isNotEmpty)
               .toList();
      }else{
        throw Exception("Server returned error :${response.statusCode} ");
        }
    }catch(e){
      print('Error fetching news from Node.js backend: $e');
      throw Exception("Failed to fetch news");
    }
  }

  Future<List<Article>> _fetchKeywordNews(String keyword) async {
     throw UnimplementedError('Moved to backend, endpoint not built yet');
  }
}