import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/providers/bookmark_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Bookmarkscreen extends StatelessWidget {
  const Bookmarkscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmarked Articles",style: TextStyle(fontWeight: FontWeight.w600),),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors:[Color(0XFFc2e59c), Color(0XFF64b3f4)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight
              )
          ),
        ),
      ),
      body: Consumer<BookmarkProvider>(
        builder: (context, bookmarkProvider, child) {
          final bookmarks =  bookmarkProvider.bookmarks;

          if(bookmarks.isEmpty){
            return const Center(
              child: Text(
                "You have no saved articles.",
                style:  TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
           return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context,index){
              final article = bookmarks[index];
              return _BookmarksArticleCard(article: article);
            }
            );
        } ,
      ),

    );
  }
}

class _BookmarksArticleCard extends StatelessWidget{
  final Article article;
  const _BookmarksArticleCard({required this.article});

  Future<void> _launchURL(String urlString) async{
    final Uri url =Uri.parse(urlString);
    if(!await launchUrl(url,mode: LaunchMode.externalApplication)){
      print("Could not launch $urlString");
    }
  }

  @override
  Widget build(BuildContext context) {
   return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              Image.network(
                article.urlToImage!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: Icon(Icons.broken_image, color: Colors.grey[400], size: 50),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (article.description != null)
                    Text(
                      article.description!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  const SizedBox(height: 12),
                  
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => _launchURL(article.url),
                      child: const Text(
                        'Read More...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF64b3f4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
      ),

    ),
    );
    
  }
}