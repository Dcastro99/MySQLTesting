import 'package:flutter/material.dart';
import 'package:login/pages/home_page.dart';
import 'package:login/pages/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:login/pages/my_data_page.dart';
import 'package:login/pages/permissions_edit_page.dart';
import 'package:login/pages/permissions_page.dart';
import 'package:login/pages/register_page.dart';
import 'package:login/services/login_api.dart';
import 'package:login/services/user_provider.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserData(), // Provide an instance of UserData
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/data': (context) => const DataPage(),
        // '/permissions': (context) => const PermissionsPage(),
      },
    );
  }
}
