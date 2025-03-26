import 'package:flutter/material.dart';
import 'package:peony/utils/use_model.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../generated/l10n.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0.8,
        title: Text(S.of(context).title),
        actions: [
          TextButton(
              onPressed: () =>
                  Provider.of<UseModel>(context, listen: false).changeTheme(),
              child: Text('切换')),
          TextButton(
              onPressed: () => signUpUser('jurelxc@163.com', '49856328624.'),
              child: Text('注册')),
          TextButton(
              onPressed: () => loginUser('jurelxc@163.com', '49856328624.'),
              child: Text('登录')),
          TextButton(
              onPressed: () => insertPost('学会', ),
              child: Text('插入'))
        ],
      ),
      body: Column(),
    );
  }

  Future<void> signUpUser(String email, String password) async {
    final response = await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) {
      print('User registered successfully');
    } else {
      print('${response.session} ');
    }
  }


  Future<void> loginUser(String email, String password) async {
    final response = await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );


    if (response.user == null) {
      print('User registered successfully');
    } else {
      print('${response.session} ');
    }
  }
  Future<void> insertPost(String title,) async {
    final response = await Supabase.instance.client
        .from('article')  // 替换为你的表名
        .insert([{'article': title,}
    ]);

    if (response.error == null) {
      print('Data inserted successfully');
    } else {
      print('Error inserting data: ${response.error!.message}');
    }
  }

}



///
