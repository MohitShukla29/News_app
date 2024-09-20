import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Models/categoryNewsModel.dart';
import 'package:news_app/Screens/details.dart';
import 'package:news_app/view_model/news_view_model.dart';

NewsViewModel newsViewModel = NewsViewModel();
final format = DateFormat('MMMM dd yy');
String Category = 'general';
List<String> CategoriesList = [
  'general',
  'entertainment',
  'health',
  'business',
  'science',
  'sports',
  'technology',
];

class Category_screen extends StatefulWidget {
  const Category_screen({super.key});

  @override
  State<Category_screen> createState() => _Category_screenState();
}

class _Category_screenState extends State<Category_screen> {
  int? selectedindex;

  // Function to change the color on click
  void changeColor(int index) {
    setState(() {
      // Toggling between purple and blue
      selectedindex=index;
    });
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          // Horizontal Category List
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: CategoriesList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      Category = CategoriesList[index];
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap:()=>changeColor(index),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: selectedindex == index ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          CategoriesList[index].toString(),
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Expanded ListView for News Articles
          Expanded(
            child: FutureBuilder<CategoryNews>(
              future: newsViewModel.fetchCategorydetails(Category),
              builder: (BuildContext context, snapshot) {
                // Show loading spinner while waiting

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitFadingFour(
                      color: Colors.purple,
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
                    child:
                        Text('No articles available for the selected source.'),
                  );
                }
                // Show news articles if available
                else {
                  final articles = snapshot.data?.articles ?? [];
                  return ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      DateTime datetime =
                          DateTime.parse(article.publishedAt.toString());

                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            // Article Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Details(
                                                newsImage:
                                                    article.urlToImage ?? '',
                                                newstitle:
                                                    article.title ?? 'No Title',
                                                description:
                                                    article.description ??
                                                        'No Description',
                                                publishedAt: format.format(
                                                    article.publishedAt ??
                                                        DateTime.now()),
                                                newsChannel: article
                                                        .source?.name
                                                        ?.toString() ??
                                                    'Unknown Source',
                                              )));
                                },
                                child: CachedNetworkImage(
                                  imageUrl: article.urlToImage ?? '',
                                  fit: BoxFit.cover,
                                  height: height * .18,
                                  width: width * .3,
                                  placeholder: (context, url) =>
                                      const SpinKitFadingCircle(
                                    color: Colors.blue,
                                    size: 20.0,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Container(
                                  height: height * 0.18,
                                  width: width * 0.6,
                                  child: Column(children: [
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
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ])),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
