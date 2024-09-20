import 'package:news_app/Models/categoryNewsModel.dart';
import 'package:news_app/Models/newsModel.dart';
import 'package:news_app/Repository/news_repo.dart';

class NewsViewModel{
  final _res=Newsrepo();
  Future<Newsdetails>fetchNewsHeadlines(String name) async{
    final response=await _res.fetchNewsHeadlines(name);
    return response;
  }
  Future<CategoryNews>fetchCategorydetails(String Category) async{
    final response=await _res.fetchCategorydetails(Category);
    return response;
  }
}