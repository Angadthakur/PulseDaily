import 'dart:io';

class ApiConstants {
  static String get baseUrl {
    if(Platform.isAndroid){
      return 'http://10.0.2.2:3000/api';
    }
    return 'http://localhost:3000/api';
  }

  static String get newsEndpoint => '$baseUrl/news/top-headlines';
  static String get authLoginEndpoint => '$baseUrl/auth/login';
  static String get authRegisterEndpoint => '$baseUrl/auth/register';
  static String get bookmarksEndpoint => '$baseUrl/bookmarks';
}


