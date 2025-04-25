import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peony/peony.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<ArticleBean> articleList = [];
  Color confirmColor = const Color(0xff0D57BB);
  Color basicColor = const Color(0xff7AAAEA);
  int curIndex = 0;

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
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
                    top: 50,
                    right: 200,
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
                        height: 20,
                        width: 70,
                        color: Colors.cyan,
                        child: const Text(
                          " 我的掘金",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    top: 120,
                    left: 40,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 70, // 圆形半径
                          backgroundImage:
                              AssetImage(Assets.avatar), // 网络图片// 本地资源图片
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "衿璃",
                          style: TextStyle(
                            color: Color(0xfff57c1a),
                            fontSize: 30,
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
                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
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
                          padding: const EdgeInsets.all(10,),
                          child: Text(
                            barName[index],
                            style:
                                const TextStyle(color: Colors.white, fontSize: 24),
                            textAlign: TextAlign.center,
                          ),
                        ))),
            GestureDetector(
              onTap: () {
                context.go('/diary');
              },
              child: const Text("跳转"),
            ),

            // SizedBox(
            //   height: 671.w,
            //   child: TabBarView(controller: tabController, children: [
            //     ArticlePage(
            //       articles: articleList,
            //     ),
            //     const JsonAnalysisTool(),
            //     // DiaryPage(),
            //     MessagePage(),
            //     MePage(),
            //   ]),
            // )
          ],
        ),
      ),
    );
  }
}
