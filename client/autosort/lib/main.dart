import 'package:autosort/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'theme.dart';
import 'main_layout.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize window_manager for native title bar
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(1100, 750), // Default startup size
    center: true,
    backgroundColor: Colors.black,
    title: 'AutoSort',
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  // Use bitsdojo to enforce min/max size
  doWhenWindowReady(() {
    appWindow.minSize = const Size(1100, 750); // Minimum size
    appWindow.maxSize = const Size(1400, 900); // Maximum size
    appWindow.alignment = Alignment.center; // Start centered
  });

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoSort',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const MainLayout(),
    );
  }
}
