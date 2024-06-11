import 'package:flutter/material.dart';
import 'package:peony/entities/article_model.dart';

///我的文章
class ArticlePage extends StatefulWidget {
  final List<ArticleBean> articles;
  const ArticlePage({super.key, required this.articles});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(itemBuilder: (_,index){
        return _articleItem(widget.articles[index]);
      },itemCount:widget.articles.length ,)
    );
  }
}

Widget _articleItem(ArticleBean item) {
  return GestureDetector(
    onTap: (){},
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
