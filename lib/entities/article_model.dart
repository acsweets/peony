/// title : "使用Flutter 完成我的静态博客（一）构思界面"
/// description : "一直都想写一个自己的博客，因为Flutter能够支持web，就还挺方便的。所以设计并构思了一下自己的博客"
/// url : "https://juejin.cn/post/7361973121790328882"
/// time : "2024-04-26"

class ArticleBean {
  String? title;
  String? description;
  String? url;
  String? time;

  ArticleBean({this.title, this.description, this.url, this.time});

  static ArticleBean fromMap(Map<String, dynamic> map) {
    ArticleBean articleBean = ArticleBean();
    articleBean.title = map['title'];
    articleBean.description = map['description'];
    articleBean.url = map['url'];
    articleBean.time = map['time'];
    return articleBean;
  }

  Map toJson() => {
        "title": title,
        "description": description,
        "url": url,
        "time": time,
      };
}
