import 'package:flutter/material.dart';
import 'package:peony/peony.dart';
class MyWeb extends StatelessWidget {
  const MyWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '衿璃的博客',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  ScreenUtilInit (designSize :  const Size(1440, 1024),  builder:(_, child) {
        return  const MyHomePage();
      }),
    );
  }
}
