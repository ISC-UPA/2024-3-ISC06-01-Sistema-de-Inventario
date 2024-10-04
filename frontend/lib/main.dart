import 'package:flutter/material.dart';
import 'package:frontend/pages/home.dart';
import 'package:frontend/theme/app_theme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Crea el tema antes de ejecutar runApp()
  final themeNotifier = AppThemeNotifier();
  await themeNotifier.loadTheme();

  runApp(MyApp(themeNotifier: themeNotifier));
}

class MyApp extends StatelessWidget {
  final AppThemeNotifier themeNotifier;

  const MyApp({super.key, required this.themeNotifier});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider.value(
      value: themeNotifier,
      child: Consumer<AppThemeNotifier>(
        builder: (context, tema, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: tema.appTheme.getTheme(),
            initialRoute: '/home',
            routes: {
              '/home': (context) => HomePage(themeNotifier: tema),
            },
          );
        },
      ),
    );
  }
}
