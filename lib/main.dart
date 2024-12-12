import 'package:flutter/material.dart';
import 'package:tiktok/favorite_list.dart';
import 'package:tiktok/tiktok.dart';

void main() {
  runApp(const TikTokApp());
}

class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => const TikTok(),
        'favorite': (context) => const FavoriteListPage(),
      },
    );
  }
}
