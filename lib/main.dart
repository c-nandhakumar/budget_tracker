import 'package:budget_app/common/screen_size.dart';
import 'package:budget_app/provider/app_provider.dart';
import 'package:budget_app/screens/Welcome/welcome_screen.dart';
import 'package:budget_app/screens/bottomnavigation.dart';
import 'package:budget_app/screens/home_screen.dart';
import 'package:budget_app/services/firebase_auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common/color_schemes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (context) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
            create: (context) => context.read<FirebaseAuthMethods>().authState,
            initialData: null),
        ChangeNotifierProvider(
          create: (context) => BackEndProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Budget App',
        theme: ThemeData(
            colorScheme: lightColorScheme,
            fontFamily: 'Inter',
            textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Inter'),
            useMaterial3: true),
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if (firebaseUser != null) {
      return BottomNavBar();
    } else {
      return WelcomeScreen();
    }
  }
}
