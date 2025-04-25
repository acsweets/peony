import 'package:flutter/material.dart';

/// 碎碎念
class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('me'),
    );
  }
}
