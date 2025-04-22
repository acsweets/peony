import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

///根据
class WebNav extends StatefulWidget {
  final Widget? login;
  final Widget? body;

  // final List<String> menus;

  const WebNav({
    super.key,
    this.login,
    this.body,
    // required this.menus
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
          Row(
            children: [
              itemNav(),
              GestureDetector(
                onTap: () {
                  context.go('/me');
                },
                child: const Text("跳转me"),
              ),
            ],
          ),
          if (widget.body != null) Expanded(child: widget.body!),
        ],
      ),
    );
  }

  Widget itemNav() {
    return GestureDetector(
      onTap: () {
        context.go('/diary');
      },
      child: const Text("跳转"),
    );
  }
}
