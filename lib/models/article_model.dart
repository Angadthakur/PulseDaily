class Article {
  final String title;
  final String? description;
  final String? urlToImage;
  final String url;
  final String? author;
  final String publishedAt;
  final String? content;

  Article({
    required this.title,
    this.description,
    this.urlToImage,
    required this.url,
    this.author,
    required this.publishedAt,
    this.content
  });

  factory Article.fromJson(Map<String, dynamic> json){
    return Article(
      title: json['title'] ?? 'No Title', 
      description: json['description'],
      urlToImage: json['urlToImage'],
      url: json['url'] ?? '',
      author: json['author'],
      publishedAt: json['publishedAt'] ?? '',
      content: json['content'],
      );
  }
}