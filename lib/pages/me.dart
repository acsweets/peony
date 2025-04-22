import 'package:flutter/material.dart';
///关于我
class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('me'),
    );
  }
}
