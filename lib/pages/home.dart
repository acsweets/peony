import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peony/peony.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<ArticleBean> articleList = [];
  Color confirmColor = const Color(0xff0D57BB);
  Color basicColor = const Color(0xff7AAAEA);
  int curIndex = 0;

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    loadArticleFromAsset();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 14 / 4,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: Image.asset(
                          Assets.bg_2,
                          fit: BoxFit.cover,
                        )),
                  ),
                  Positioned(
                    top: 50.w,
                    right: 200.w,
                    child: GestureDetector(
                      onTap: () async {
                        Uri url = Uri.https(
                          'juejin.cn',
                          '/user/1834404269803310',
                        );
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Container(
                        height: 20.w,
                        width: 70.w,
                        color: Colors.cyan,
                        child: Text(
                          " 我的掘金",
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 120.w,
                    left: 40.w,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 70.w, // 圆形半径
                          backgroundImage: const AssetImage(Assets.avatar), // 网络图片// 本地资源图片
                        ),
                        SizedBox(
                          height: 15.w,
                        ),
                        Text(
                          "衿璃",
                          style: TextStyle(
                            color: const Color(0xfff57c1a),
                            fontSize: 30.sp,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            TabBar(
                dividerHeight: 0,
                //指示器颜色
                indicatorColor: Colors.transparent,
                controller: tabController,
                // indicator: const BoxDecoration(
                //   color: Color(0xff0D57BB), // 设置overlayColor的颜色
                // ),
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    // return const Color(0xff7AAAEA);
                    //如果不想设置未选中时的overlayColor，返回null
                    // return const Color(0xff0D57BB); // 例如：半透明的蓝色
                    return Colors.transparent;
                  },
                ),
                onTap: (i) {
                  curIndex = i;
                  setState(() {});
                },
                tabs: List.generate(
                    barName.length,
                    (index) => Container(
                          color: curIndex == index ? confirmColor : basicColor,
                          width: double.infinity,
                          padding: EdgeInsets.only(top: 10.w, bottom: 10.w, left: 10.w, right: 10.w),
                          child: Text(
                            barName[index],
                            style: TextStyle(color: Colors.white, fontSize: 24.sp),
                            textAlign: TextAlign.center,
                          ),
                        ))),
            SizedBox(
              height: 671.w,
              child: TabBarView(controller: tabController, children: [
                ArticlePage(
                  articles: articleList,
                ),
                DiaryPage(),
                MessagePage(),
                MePage(),
              ]),
            )
          ],
        ),
      ),
    );
  }

  /// 读取文章
  Future<void> loadArticleFromAsset() async {
    String content = await rootBundle.loadString(Assets.articleData);
    Map<String, dynamic> configAsMap = json.decode(content);
    articleList = (configAsMap["articleList"] as List).map((e) => ArticleBean.fromMap(e)).toList();
    setState(() {});
  }
}
