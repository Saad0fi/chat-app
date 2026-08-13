import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sao/core/setup.dart';
import 'package:sao/feature/auth/screens/sign_up_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Setup().init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar', 'SA'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: SignUpScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
