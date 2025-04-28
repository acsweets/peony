import 'dart:ui_web';

import 'package:flutter/material.dart';
import 'package:peony/peony.dart';
import 'package:peony/utils/font_http_load.dart';
import 'package:peony/utils/use_model.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = 'https://enebqamopxtbsyojrsvx.supabase.co';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVuZWJxYW1vcHh0YnN5b2pyc3Z4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg4MjM2NzcsImV4cCI6MjA1NDM5OTY3N30._-waTE_BULxq31uBa5P4jCth-Z8Q9gjgXU4qcA5s-8E';

Future<void> main() async {
  GoRouter.optionURLReflectsImperativeAPIs = true;
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  loadHttpFont(fontFamily: 'cute', urlString: '/peony/cute.ttf');
  loadHttpFont(fontFamily: 'seagull', urlString: '/peony/seagull.ttf');

  const HashUrlStrategy();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UseModel()),
      ],
      child: const MyWeb(),
    ),
  );
}

// Get a reference your Supabase client
final supabase = Supabase.instance.client;
