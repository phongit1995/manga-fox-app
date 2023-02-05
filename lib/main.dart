import 'package:flutter/material.dart';
import 'package:manga_fox_app/core/app_config/theme/theme_data.dart';
import 'package:manga_fox_app/ui/home/home_page.dart';
import 'package:manga_fox_app/ui/library/library_page.dart';

import 'ui/manga_reader/manga_reader_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeData>(
      builder: (context, theme, child) {
        return MaterialApp(
          theme: theme,
          darkTheme: AppThemData.dark,
          home: HomePage(),
        );
      },
      valueListenable: AppThemData().themeData,
    );
  }
}
