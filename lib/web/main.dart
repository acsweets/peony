import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 500,
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SizedBox(
                      height: 500,
                      child: Swiper(
                        autoplay: true,
                        itemBuilder: (context, index) {
                          return Image.network(
                            "https://marketplace.canva.cn/NsFNI/MADwRLNsFNI/1/screen_2x/canva-blue-textured-background-MADwRLNsFNI.jpg",
                            fit: BoxFit.fill,
                          );
                        },
                        itemCount: 3,
                        pagination: const SwiperPagination(),
                        control: const SwiperControl(),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    right: 200,
                    child: GestureDetector(
                      onTap: () async {
                        Uri url = Uri.https('juejin.cn','/user/1834404269803310',);
                        if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                        } else {
                        throw 'Could not launch $url';
                        }
                      },
                      child: Container(
                        height: 20,
                        width: 50,
                        color: Colors.cyan,
                        child: Text(" 我的掘金"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TabBar(
                controller: tabController,
                tabs: List.generate(
                    3,
                    (index) => Container(
                          child: Text("我的文章"),
                        ))),
            SizedBox(
              height: 200,
              child: TabBarView(controller: tabController, children: [
                Container(
                  color: Colors.grey,
                ),
                Container(
                  color: Colors.red,
                ),
                Container(
                  color: Colors.blue,
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
