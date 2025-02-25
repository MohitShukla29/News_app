import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/Models/categoryNewsModel.dart';
import '../Models/newsModel.dart';

class Newsrepo {
  Future<Newsdetails> fetchNewsHeadlines(String name) async {
    // Ensure the source name is properly encoded
    Uri url = Uri.parse('https://newsapi.org/v2/top-headlines?sources=${Uri.encodeComponent(name)}&apiKey=2a3192acc09a486198eb02ce29a3d60b');

    // Log the URL to ensure it's formatted correctly
    print('Requesting URL: $url');

    try {
      final response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse and return the data
        return Newsdetails.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load news. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in fetchNewsHeadlines: $e');
      throw e; // Propagate the error for error handling in FutureBuilder
    }
  }

  Future<CategoryNews> fetchCategorydetails(String Category) async {
    // Ensure the source name is properly encoded
    Uri url2 = Uri.parse('https://newsapi.org/v2/everything?q=${Category}&apiKey=${dotenv.env['APIKEY']}');

    // Log the URL to ensure it's formatted correctly
    print('Requesting URL: $url2');

    try {
      final response = await http.get(url2);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse and return the data
        return CategoryNews.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load news. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in fetchNewsHeadlines: $e');
      throw e; // Propagate the error for error handling in FutureBuilder
    }
  }
}
