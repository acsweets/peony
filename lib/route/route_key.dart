enum RouteNavConfig {
  home('/home', 'home', '主页'),
  article('/article', 'article', '文章'),
  board('/board', 'board', '留言板'),
  diary('/diary', 'diary', '碎碎念'),
  aboutMe('/aboutMe', 'aboutMe', '关于我'),
  welcome('/welcome', 'welcome', '欢迎页'),
  ;

  const RouteNavConfig(this.path, this.name, this.navName);

  final String path;
  final String name;
  final String navName;

  static List<RouteNavConfig> get routeTags =>
      RouteNavConfig.values.where((e) => e != RouteNavConfig.welcome).toList();

  @override
  String toString() => home.name;
}
