import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/providers/auth_provider.dart';
import 'package:news_app/providers/bookmark_provider.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/screens/bookmarkscreen.dart';
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
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert,color: Colors.black),
            onSelected: (value) {
              if(value == "bookmarks"){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const Bookmarkscreen()));
              }else if(value == "about"){
                showAboutDialog(
                  context: context,
                  applicationName: "PulseDaily",
                  applicationVersion: "1.0.0",
                  children: [const Text("Your daily dose of global news")]
                  );
              }else if(value == "signout"){
                Provider.of<AuthProvider>(context, listen: false).signOut();
              }
            },
            itemBuilder: (BuildContext context)=> <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: "bookmarks",
                child: ListTile(
                  leading: Icon(Icons.bookmark),
                  title: Text("Bookmarks"),
                ),
                ),
                const PopupMenuItem<String>(
                value: 'about',
                child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('About'),
                ),
              ),
                const PopupMenuDivider(),

                const PopupMenuItem<String>(
                  value: "signout",
                  child: ListTile(
                    leading: Icon(Icons.logout, color: Colors.red,),
                    title: Text("Sign Out",style: TextStyle(color: Colors.red),)
                  ),
                  ),
            ]
            )
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
      
      print('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);
    final isBookmarked = bookmarkProvider.isBookmarked(article);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAlias, //ensures the image respects the border
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //article Image
            if (article.urlToImage != null)
              Image.network(
                article.urlToImage!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: Icon(Icons.broken_image,
                        color: Colors.grey[400], size: 50),
                  );
                },
              ),
            
            //article Content
            Padding(
              padding: const EdgeInsets.fromLTRB(16,16,16,8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  if (article.description != null)
                    Text(
                      article.description!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: (){
                          bookmarkProvider.toggleBookmark(article);
                        }, 
                        icon: Icon(
                          isBookmarked? Icons.bookmark :Icons.bookmark_border,
                          color: isBookmarked ? Color(0XFF64b3f4) : Colors.grey,
                          size: 30,
                        )),
                        TextButton(
                          onPressed: ()=> _launchURL(article.url), 
                          child: const Text(
                            "Read More...",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0XFF64b3f4)
                            ),
                          ))
                    ],
                  )
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
