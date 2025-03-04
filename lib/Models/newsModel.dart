import 'dart:convert';

Newsdetails newsdetailsFromJson(String str) => Newsdetails.fromJson(json.decode(str));

String newsdetailsToJson(Newsdetails data) => json.encode(data.toJson());

class Newsdetails {
  String status;
  int totalResults;
  List<Article> articles;

  Newsdetails({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory Newsdetails.fromJson(Map<String, dynamic> json) => Newsdetails(
    status: json["status"],
    totalResults: json["totalResults"],
    articles: List<Article>.from(json["articles"].map((x) => Article.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "totalResults": totalResults,
    "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
  };
}

class Article {
  Source source;
  String? author;  // Author can be null, so make it nullable
  String title;
  String? description;  // Description can be null
  String url;
  String? urlToImage;  // URL to image can be null
  DateTime publishedAt;
  String? content;  // Content can be null

  Article({
    required this.source,
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
    source: Source.fromJson(json["source"]),
    author: json["author"],  // Nullable author
    title: json["title"],
    description: json["description"],
    url: json["url"],
    urlToImage: json["urlToImage"],
    publishedAt: DateTime.parse(json["publishedAt"]),
    content: json["content"],
  );

  Map<String, dynamic> toJson() => {
    "source": source.toJson(),
    "author": author,
    "title": title,
    "description": description,
    "url": url,
    "urlToImage": urlToImage,
    "publishedAt": publishedAt.toIso8601String(),
    "content": content,
  };
}

class Source {
  String? id;  // ID can be null
  String name;

  Source({
    this.id,
    required this.name,
  });

  factory Source.fromJson(Map<String, dynamic> json) => Source(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
