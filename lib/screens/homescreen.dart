import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/providers/auth_provider.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> 
  with SingleTickerProviderStateMixin {
    late TabController _tabController;

    final List<String> _categories = [
    "Top News",
    "Sports",
    "Health",
    "Entertainment",
    "Business",
    "Technology",
    "Science"
  ];

  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);

    _tabController.addListener(_handleTabSelection);

    //wait for the first frame to be built before fetching news.
    //this prevents the "setState() called during build" error.
    WidgetsBinding.instance.addPostFrameCallback((_){
      _fetchNewsForCategory(_categories[0]);
    });
  }

  void _handleTabSelection(){
    if(_tabController.indexIsChanging){
      _fetchNewsForCategory(_categories[_tabController.index]);
    }
  }

  void _fetchNewsForCategory(String category){
    Provider.of<NewsProvider>(context,listen: false).fetchNews(category);
  }

  @override
  void dispose(){
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration:  const BoxDecoration(
            gradient: LinearGradient(
              colors:[Color(0XFFc2e59c), Color(0XFF64b3f4)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight
               ),
          ),
        ),
        title: const Text(
          'PulseDaily',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: (){
              Provider.of<AuthProvider>(context,listen: false).signOut();
            }, 
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ))
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black54,
          indicatorColor: Colors.black,
          indicatorWeight: 3.0,
          tabs: _categories.map((String category){
            return Tab(
              child: Text(
                category,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
           }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _categories.map((String category){
          return _NewsCategoryView(category:category);
        }).toList(),
      ),
 );
  }
}

class _NewsCategoryView extends StatelessWidget{
  final String category;
  const _NewsCategoryView({required this.category});

  @override
  Widget build(BuildContext context){
    return Consumer<NewsProvider>(
      builder: (context , newsProvider, child){
        final isLoading = newsProvider.isLoadingForCategory(category);
        final articles = newsProvider.getArticlesForCategory(category);
        final errorMessage = newsProvider.errorMessage;

        if(isLoading && articles.isEmpty){
          return const Center(child: CircularProgressIndicator());
        }

        if(errorMessage != null && articles.isEmpty){
          return Center(
            child: Text(
              "Failed to load news. \nPlease check your connection.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red[400], fontSize: 16
              ),
            ),
          );
        }
        if(articles.isEmpty){
          return const Center(
            child: Text(
              "No articles found for this category",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey
              ),
            ),
          );
        }

        return ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index){
            final article =  articles[index];
            return _NewsArticleCard(article:article);
          });

      } ,);
  }
}
class _NewsArticleCard extends StatelessWidget {
  final Article article;
  const _NewsArticleCard({required this.article});

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // You can show a SnackBar here if launching fails
      print('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAlias, // Ensures the image respects the border
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Image
            if (article.urlToImage != null)
              Image.network(
                article.urlToImage!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                // Show a placeholder while loading
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                // Show an icon if the image fails to load
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: Icon(Icons.broken_image,
                        color: Colors.grey[400], size: 50),
                  );
                },
              ),
            
            // Article Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Description
                  if (article.description != null)
                    Text(
                      article.description!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  const SizedBox(height: 12),
                  // Read More Button
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
