import 'package:auto_car/models/auth.dart';
import 'package:auto_car/pages/cadastro/cadastro_page.dart';
import 'package:auto_car/pages/login/splash_screen.dart';
import 'package:auto_car/pages/login_main_page.dart';
import 'package:auto_car/pages/login/login_page.dart';
import 'package:auto_car/pages/produtos_car_screen.dart';
import 'package:auto_car/utils/app_routes.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
//import 'package:firebase_core/firebase_core.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            primary: Colors.black,
            secondary: Colors.white,
            seedColor: Colors.white,
          ),
          primaryIconTheme: const IconThemeData(color: Colors.white),
          iconTheme: const IconThemeData(
            color: Colors.white, // Cor do ícone de menu suspenso (more_vert)
          ),
          useMaterial3: true,
        ),
        //home: const PageLogin(),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.HOME: (ctx) => const SplashScreen(),
          AppRoutes.LOGIN_MAIN_PAGE: (ctx) => const LoginMainPage(),
          AppRoutes.LOGIN_PAGE: (ctx) => const LoginPage(),
          AppRoutes.CADASTRO_PAGE: (ctx) => const CadastroPage(),
          AppRoutes.PROUCT_CAR: (ctx) => const ProductCarPage(),
        },
      ),
    );
  }
}
