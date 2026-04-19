import 'package:flutter/material.dart';
import 'package:flutter_wealth_curator_app/views/splash_screen_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://xyykmfoywnccceziohhw.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh5eWttZm95d25jY2NlemlvaGh3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ2MTc1ODUsImV4cCI6MjA5MDE5MzU4NX0.qEQz2QH6-Ua4VTwvcuKOq6ait0h7P-ZvOgaJRc0oPgM',
  );

  runApp(
    FlutterWealthCuratorApp(),
  );
}

class FlutterWealthCuratorApp extends StatefulWidget {
  const FlutterWealthCuratorApp({super.key});

  @override
  State<FlutterWealthCuratorApp> createState() => _FlutterWealthCuratorAppState();
}

class _FlutterWealthCuratorAppState extends State<FlutterWealthCuratorApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenUi(),
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
    );
  }
}