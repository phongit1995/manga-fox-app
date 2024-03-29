import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:manga_fox_app/applovin.dart';
import 'package:manga_fox_app/core/app_config/theme/theme_data.dart';
import 'package:manga_fox_app/core/iap_purchase.helper.dart';
import 'package:manga_fox_app/core/utils/setting_utils.dart';
import 'package:manga_fox_app/data/dao/chapter_dao.dart';
import 'package:manga_fox_app/data/dao/chapter_novel_dao.dart';
import 'package:manga_fox_app/data/dao/manga_dao.dart';
import 'package:manga_fox_app/data/response/list_chapper_response.dart';
import 'package:manga_fox_app/data/response/manga_response.dart';
import 'package:manga_fox_app/data/response/novel_chapter.dart';
import 'package:manga_fox_app/firebase_options.dart';
import 'package:manga_fox_app/ui/home/home_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

const highImportanceChannelId = 'highImportanceChannel';
const highImportanceChannelName = 'High Importance Notifications';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  if(Platform.isIOS){
      NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(MangaAdapter());
  Hive.registerAdapter(ListChapterAdapter());
  Hive.registerAdapter(NovelChapterAdapter());
  await MangaDAO.init();
  await Hive.openBox('chapter');
  await Hive.openBox('downloadImage');
  await Hive.openBox('chapterReadingDao');
  await Hive.openBox(ChapterDAO().chapterPercentReadingDao);
  await Hive.openBox(ChapterNovelDAO().chapterPercentReadingDaoNovel);
  await Hive.openBox(ChapterNovelDAO().chapterReadingDaoNovel);
  await Hive.openBox(ChapterNovelDAO().chapterDaoNovel);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await applovinServiceAds.initApplovin();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  if (await SettingUtils().initApp == null) {
    FirebaseMessaging.instance.subscribeToTopic("all");
    SettingUtils().setInitApp();
  }
    String? token = await messaging.getToken();
    print('tokenFirebase $token');
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
    IapPurchaseHelper().disposeIap();
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
          builder: EasyLoading.init(),
          debugShowCheckedModeBanner: false,
        );
      },
      valueListenable: AppThemData().themeData,
    );
  }

  @override
  void initState() {
    super.initState();
    applovinServiceAds.loadInterstital();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });
    IapPurchaseHelper().initStoreInfo();
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
