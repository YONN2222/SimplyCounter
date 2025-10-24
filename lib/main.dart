import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/counter.dart';
import 'models/counters_model.dart';
import 'pages/home_page.dart';
import 'services/storage_service.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = StorageService();
  final counters = await storage.loadCounters();

  runApp(MainApp(storage: storage, initialCounters: counters));
}

class MainApp extends StatelessWidget {
  final StorageService storage;
  final List<CounterItem> initialCounters;

  const MainApp({
    super.key,
    required this.storage,
    required this.initialCounters,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CountersModel(storage: storage, counters: initialCounters),
      child: MaterialApp(
        title: 'SimplyCounter',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('de')],
        localeResolutionCallback: (locale, supportedLocales) {
          if (locale == null) return const Locale('en');
          for (var supported in supportedLocales) {
            if (supported.languageCode == locale.languageCode) return supported;
          }
          return const Locale('en');
        },
        theme: ThemeData(
          brightness: Brightness.light,
          textTheme: GoogleFonts.interTextTheme(),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0066FF)),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          textTheme: GoogleFonts.interTextTheme(
            ThemeData(brightness: Brightness.dark).textTheme,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF66AAFF),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
