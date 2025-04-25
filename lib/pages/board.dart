import 'package:flutter/material.dart';
///留言板
class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('BoardPage'),
    );
  }
}
