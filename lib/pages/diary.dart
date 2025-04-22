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
    return Text('Diary');
  }
}
// Swiper(
// autoplay: true,
// itemBuilder: (context, index) {
// return Image.asset(
// Assets.bg_3,
// fit: BoxFit.fill,
// );
// },
// itemCount: 3,
// pagination: const SwiperPagination(),
// control: const SwiperControl(),
// ),
