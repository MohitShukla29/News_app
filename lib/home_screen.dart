import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/Models/newsModel.dart';
import 'package:news_app/Screens/categories_screen.dart';
import 'package:news_app/Screens/details.dart';
import 'package:news_app/view_model/news_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import 'Models/categoryNewsModel.dart';

enum FilterList { bbcNews, cnn, abcNews,espncricinfo ,espn}

FilterList? selectedmenu;
String name = 'abc-news'; // Default source ID

class Home_screen extends StatefulWidget {
  const Home_screen({super.key});

  @override
  State<Home_screen> createState() => _Home_screenState();
}

class _Home_screenState extends State<Home_screen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    final format = DateFormat('MMMM dd yy');
    NewsViewModel newsViewModel = NewsViewModel();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Category_screen()));
          },
          icon: Image.asset(
            'images/category_icon.png',
            height: 30,
            width: 30,
          ),
        ),
        title: Center(
          child: Text(
            'News',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedmenu,
            onSelected: (FilterList item) {
              setState(() {
                selectedmenu = item;
                if (FilterList.cnn == item) {
                  name = 'cnn';
                } else if (FilterList.abcNews == item) {
                  name = 'abc-news';
                } else if (FilterList.bbcNews == item) {
                  name = 'bbc-news';
                } else if (FilterList.espn == item) {
                  name = 'espn';
                }
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
              PopupMenuItem<FilterList>(
                value: FilterList.bbcNews,
                child: Text('BBC News'),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.cnn,
                child: Text('CNN'),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.abcNews,
                child: Text('ABC News'),
              ),
              PopupMenuItem<FilterList>(
                value: FilterList.espn,
                child: Text('ESPN'),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .55,
            width: width * .9,
            child: FutureBuilder<Newsdetails>(
              future: newsViewModel.fetchNewsHeadlines(name),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitFadingCircle(
                      color: Colors.yellow,
                      size: 70,
                    ),
                  );
                } else if (snapshot.hasError) {
                  debugPrint(
                      'Error: ${snapshot.error}'); // Log the actual error
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData ||
                    snapshot.data?.articles == null ||
                    snapshot.data!.articles!.isEmpty) {
                  return Center(
                    child:
                        Text('No articles available for the selected source.'),
                  );
                } else {
                  final articles = snapshot.data?.articles ?? [];
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: height * .6,
                            width: width,
                            padding:
                                EdgeInsets.symmetric(horizontal: height * .02),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Details( newsImage: article.urlToImage ?? '',
                                  newstitle: article.title ?? 'No Title',
                                  description: article.description?.toString() ?? 'No Description',
                                  publishedAt: format.format(article.publishedAt ??
                                      DateTime.now()),
                                  newsChannel: article.source?.name?.toString() ?? 'Unknown Source',)));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: article.urlToImage ??
                                      '', // Fallback for null
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    child: SpinKitFadingCircle(
                                      color: Colors.yellow,
                                      size: 70.0,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            child: Card(
                              elevation: 5,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                height: height * .2,
                                width: width * .9,
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Text(
                                      article.title ??
                                          'No Title', // Fallback for
                                      style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 3,
                                    ),
                                    Spacer(),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            article.source?.name?.toString() ??
                                                'Unknown Source',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          format.format(article.publishedAt ??
                                              DateTime.now()),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },

                  );

                }
              },
            ),
          ),

          FutureBuilder<CategoryNews>(
              future: newsViewModel.fetchCategorydetails('general'),
              builder: (BuildContext context, snapshot) {
                // Show loading spinner while waiting

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitFadingCircle(
                      color: Colors.yellow,
                      size: 70,
                    ),
                  );
                }
                // Handle errors
                else if (snapshot.hasError) {
                  debugPrint('Error: ${snapshot.error}');
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                // Handle empty data
                else if (!snapshot.hasData ||
                    snapshot.data?.articles == null ||
                    snapshot.data!.articles!.isEmpty) {
                  return const Center(
                    child: Text('No articles available for the selected source.'),
                  );
                }
                // Show news articles if available
                else {
                  final articles = snapshot.data?.articles ?? [];
                  return ListView.builder(
                    itemCount: articles.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      DateTime datetime = DateTime.parse(
                          article.publishedAt.toString());

                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            // Article Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Details( newsImage: article.urlToImage ?? '',
                                    newstitle: article.title ?? 'No Title',
                                    description: article.description?.toString() ?? 'No Description',
                                    publishedAt: format.format(article.publishedAt ??
                                        DateTime.now()),
                                    newsChannel: article.source?.name?.toString() ?? 'Unknown Source',)));
                                },
                                child: CachedNetworkImage(
                                  imageUrl: article.urlToImage ?? '',
                                  fit: BoxFit.cover,
                                  height: height * .18,
                                  width: width * .3,
                                  placeholder: (context, url) => const SpinKitFadingCircle(
                                    color: Colors.yellow,
                                    size: 40.0,
                                  ),
                                  errorWidget: (context, url, error) => const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:EdgeInsets.only(left: 10),
                              child: Container(
                                  height: height * 0.18,
                                  width: width * 0.6,
                                  child: Column(
                                      children: [
                                        Text(
                                          article.title ??
                                              'No Title', // Fallback for
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          maxLines: 3,
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                article.source?.name?.toString() ??
                                                    'Unknown Source',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              format.format(article.publishedAt ??
                                                  DateTime.now()),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]
                                  )
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),

        ],
      ),
    );
  }
}
