import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../route/route_key.dart';

///根据
class WebNav extends StatefulWidget {
  final Widget? body;

  const WebNav({
    super.key,
    this.body,
  });

  @override
  State<WebNav> createState() => _WebNavState();
}

class _WebNavState extends State<WebNav> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(width: 0.5, color: Colors.grey))),
            padding: const EdgeInsets.only(
                left: 20.0, right: 20, bottom: 10, top: 20),
            child: Row(
              children: [
                Text(
                  '热爱让记录变得有意义',
                  style: TextStyle(
                      fontFamily: 'cute',
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Colors.blue.withValues(alpha: 0.5)),
                ),
                const Spacer(),
                ...RouteNavConfig.routeTags.map((e) => itemNav(e)),
              ],
            ),
          ),
          if (widget.body != null) Expanded(child: widget.body!),
        ],
      ),
    );
  }

  Widget itemNav(RouteNavConfig route) {
    final isActive = GoRouter.of(context).state.path == route.path;
    return GestureDetector(
      onTap: () {
        context.go(route.path);
      },
      child: Container(
        padding: const EdgeInsets.only(right: 15),
        child: Text(
          route.navName,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: isActive ? Colors.blue : Colors.black),
        ),
      ),
    );
  }
}
