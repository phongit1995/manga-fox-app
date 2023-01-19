import 'package:flutter/material.dart';
import 'package:manga_fox_app/core/app_config/theme/theme_data.dart';
import 'package:manga_fox_app/ui/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppThemData.dark,
      home: HomePage(),
    );
  }
}
