import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:manga_fox_app/core/app_config/theme/theme_data.dart';
import 'package:manga_fox_app/core/utils/setting_utils.dart';
import 'package:manga_fox_app/data/dao/manga_dao.dart';
import 'package:manga_fox_app/data/response/list_chapper_response.dart';
import 'package:manga_fox_app/data/response/manga_response.dart';
import 'package:manga_fox_app/ui/home/home_page.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(MangaAdapter());
  Hive.registerAdapter(ListChapterAdapter());
  await MangaDAO.init();
  await Hive.openBox('chapter');
  await Hive.openBox('downloadImage');
  await Hive.openBox('chapterReadingDao');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

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

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () async {
        AppThemData().themeData.value = await SettingUtils().dartMode
            ? AppThemData.dark
            : AppThemData.light;
      },
    );
  }
}
