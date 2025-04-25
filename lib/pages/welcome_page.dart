import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../asset/asset.dart';
import '../route/route_key.dart';
import '../utils/use_model.dart';

///文字渐渐变实
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // 动画持续时间
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UseModel>(context, listen: false).changeInitState();
    });

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward(); // 开始动画
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.welcomeBg), // 替换为你的图片路径
          fit: BoxFit.cover, // 关键参数，让图片铺满整个容器
        ),
      ),
      child: Center(
        child: FadeTransition(
          opacity: _fadeAnimation, // 💡 淡入动画
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '欢迎来到衿璃的博客',
                style: TextStyle(
                    color: Color(0xff666666),
                    fontSize: 60,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 32,
              ),
              const Text(
                '每一次尝试，都是进步的伏笔。',
                style: TextStyle(
                  color: Color(0xff666666),
                  fontSize: 32,
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              TextButton(
                  onPressed: () => context.go(RouteNavConfig.home.path),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xff4B9CD3),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '开启阅读之旅',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Icon(
                          Icons.arrow_right_alt,
                          color: Colors.white,
                          size: 20,
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    ));
  }
}
