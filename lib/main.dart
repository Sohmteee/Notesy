import 'package:notesy/res/res.dart';

Future<void> main() async {
  SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

  await Hive.initFlutter();
  box = await Hive.openBox('notes');

  Hive.registerAdapter(NoteAdapter());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: (context, _) {
      return MaterialApp(
        title: 'Notesy',
        theme: lightTheme,
        darkTheme: darkTheme,
        home: const NotesScreen(),
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
