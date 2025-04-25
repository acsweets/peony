import 'package:flutter/material.dart';
import 'package:peony/json_parser/parser_json.dart';
import 'package:peony/route/route_key.dart';
import 'package:provider/provider.dart';

import '../pages/board.dart';
import '../pages/welcome_page.dart';
import '../peony.dart';
import '../utils/use_model.dart';
import '../widgets/navigation/web_nav.dart';

///路由还有个重定向
// GoRouter configuration
final router = GoRouter(
  initialLocation: '/welcome',
  redirect: (BuildContext context, GoRouterState state) {
    final bool isFirst = Provider.of<UseModel>(context, listen: false).first;
    ///如果你需要支持带参数或者嵌套路由（比如 /welcome/info），可以用 startsWith 来判断：
    final goingToWelcome = state.uri.path == '/welcome';

    if (isFirst) {
      // 首次进入，可以跳转到 /welcome
      return null;
    }

    if (!isFirst && goingToWelcome) {
      // 已经不是首次进入，但又想跳到 /welcome，不允许，重定向到 /me
      return '/me';
    }

    return null; // 其他路径正常跳转
  },
  routes: [
    ShellRoute(
      routes: [
        GoRoute(
          name: RouteNavConfig.diary.name,
          path: RouteNavConfig.diary.path,
          pageBuilder: (context, state) => buildPageWithAnimation(
            state: state,
            child: const DiaryPage(),
          ),
        ),
        GoRoute(
          name: RouteNavConfig.aboutMe.name,
          path: RouteNavConfig.aboutMe.path,
          pageBuilder: (context, state) => buildPageWithAnimation(
            state: state,
            child: const MePage(),
          ),
        ),
        GoRoute(
          name: RouteNavConfig.home.name,
          path: RouteNavConfig.home.path,
          pageBuilder: (context, state) => buildPageWithAnimation(
            state: state,
            child: const HomePage(),
          ),
        ),
        GoRoute(
          name: RouteNavConfig.board.name,
          path: RouteNavConfig.board.path,
          pageBuilder: (context, state) => buildPageWithAnimation(
            state: state,
            child: const BoardPage(),
          ),
        ),
        GoRoute(
          name: RouteNavConfig.article.name,
          path: RouteNavConfig.article.path,
          pageBuilder: (context, state) => buildPageWithAnimation(
            state: state,
            child: const ArticlePage(),
          ),
        ),
      ],
      builder: (context, state, child) {
        return WebNav(
          body: child, // 二级导航和主内容区域
        );
        return child;
      },
    ),
    GoRoute(
        name: RouteNavConfig.welcome.name,
        path: RouteNavConfig.welcome.path,
        pageBuilder: (context, state) => buildPageWithAnimation(
              state: state,
              child: const WelcomePage(),
            ),
        builder: (context, state) => const WelcomePage()),
  ],
);

Page<T> buildPageWithAnimation<T>({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: kSlideBottomToTopWithSecondary,
  );
}

///默认情况下， A 进入 B 界面， A 界面是静止不动的。而 secondaryAnimation 的价值在于:
//
// 推入路由 B 时， 旧顶层路由 A 的 secondaryAnimation 将从 0.0 运行到 1.0，从而有退出动画效果。
// 路由 B 退出时， 下层路由 A 的 secondaryAnimation 将从 1.0 运行到 0.0，从而有进入动画效果。
// 使用 secondaryAnimation 可以让非顶层，但可视的路由拥有动画效果，可以让界面间的跳转更加自然和流畅。
RouteTransitionsBuilder kSlideBottomToTopWithSecondary = (
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: animation,
    child: child,
  );
  // return SlideTransition(
  //   position: Tween<Offset>(
  //     begin: const Offset(0.0, 1.0),
  //     end: Offset.zero,
  //   ).animate(animation),
  //   child: SlideTransition(
  //     position: Tween<Offset>(
  //       begin: Offset.zero,
  //       end: const Offset(0.0, 1.0),
  //     ).animate(secondaryAnimation),
  //     child: child,
  //   ),
  // );
};

RouteTransitionsBuilder kSlideRotateFadeInWithSecondary = (
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  final rotateOut = RotationTransition(
    turns: Tween<double>(
      begin: 0.0,
      end: 0.1, // 旋转角度（可调）
    ).animate(
        CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInOut)),
    child: FadeTransition(
      opacity: Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).animate(
          CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeIn)),
      child: child,
    ),
  );

  /// 页面进入时动画
  final slideIn = SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(1.0, 0.0), // 右侧开始
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
    child: rotateOut,
  );
  // 旧页面：旋转 + 淡出
  return slideIn;

  //淡入
  // return FadeTransition(
  //   opacity: animation,
  //   child: child,
  // );
  ///幻灯片
  //     return SlideTransition(
  //       position: Tween<Offset>(
  //         begin: const Offset(1, 0),
  //         end: Offset.zero,
  //       ).animate(animation),
  //       child: child,
  //     );
};
