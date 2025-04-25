import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peony/entities/article_model.dart';

import '../asset/asset.dart';

///我的文章
class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  List<ArticleBean> articleList = [];

  @override
  void initState() {
    loadArticleFromAsset();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemBuilder: (_, index) {
        return _articleItem(articleList[index]);
      },
      itemCount: articleList.length,
    ));
  }

  /// 读取文章
  Future<void> loadArticleFromAsset() async {
    String content = await rootBundle.loadString(Assets.articleData);
    Map<String, dynamic> configAsMap = json.decode(content);
    articleList = (configAsMap["articleList"] as List)
        .map((e) => ArticleBean.fromMap(e))
        .toList();
    setState(() {});
  }

  Widget _articleItem(ArticleBean item) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        child: Column(
          children: [
            Text("${item.title}"),
            Text("${item.description}"),
            Text("${item.time}"),
          ],
        ),
      ),
    );
  }
}
