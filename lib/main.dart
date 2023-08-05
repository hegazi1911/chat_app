import 'package:chat_app/Pages/chat_page.dart';
import 'package:chat_app/Pages/register_page.dart';
import 'package:chat_app/Pages/signin_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  ChatApp({super.key});
  final _router = GoRouter(
    routes: [...routesList],
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

List<GoRoute> routesList = [
  GoRoute(
    path: Routes.signInPage,
    builder: (context, state) => const SignInPage(),
  ),
  GoRoute(
    path: Routes.registerPage,
    builder: (context, state) => const RegisterPage(),
  ),
  GoRoute(
    path: Routes.chatPage,
    name: Routes.chatPage,
    builder: (context, state) => ChatPage(
      email: state.pathParameters[Constants.email],
    ),
  ),
];

class Routes {
  static String get signInPage => '/';
  static String get registerPage => '/registerPage';
  static String get chatPage => '/chatPage/:email';
}

class Constants {
  static String get email => 'email';
}
