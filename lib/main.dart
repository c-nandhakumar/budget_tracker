import 'package:budget_app/common/screen_size.dart';
import 'package:budget_app/provider/app_provider.dart';
import 'package:budget_app/screens/Welcome/welcome_screen.dart';
import 'package:budget_app/screens/bottomnavigation.dart';
import 'package:budget_app/services/firebase_auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'common/color_schemes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

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
            dialogTheme: DialogTheme.of(context).copyWith(
                shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            )),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)))),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )))),
            filledButtonTheme: FilledButtonThemeData(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            )))),
            colorScheme: lightColorScheme,
            fontFamily: 'Inter',
            textTheme: Theme.of(context).textTheme.apply(
                fontSizeFactor: (SizeConfig.screenWidth! > 768)
                    ? 1.125
                    : (SizeConfig.screenHeight! < 750)
                        ? 0.725
                        : 0.875,
                fontSizeDelta: 1.75,
                fontFamily: 'Inter'),
            useMaterial3: true),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if (firebaseUser != null && firebaseUser.emailVerified) {
      return ShowCaseWidget(builder: Builder(builder: (context) {
        return const BottomNavBar();
      }));
    } else {
      return ShowCaseWidget(builder: Builder(builder: (context) {
        return const WelcomeScreen();
      }));
    }
  }
}
