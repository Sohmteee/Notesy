import 'package:notesy/res/res.dart';

Future<void> main() async {
  SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());

  box = await Hive.openBox('box');

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
