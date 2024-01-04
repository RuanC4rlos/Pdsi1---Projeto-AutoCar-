import 'package:auto_car/models/auth.dart';
import 'package:auto_car/models/car_list.dart';
import 'package:auto_car/models/carrinho.dart';
import 'package:auto_car/pages/carrinho_page.dart';
import 'package:auto_car/pages/favorite_page.dart';
import 'package:auto_car/pages/autenticacao/splash_screen.dart';
import 'package:auto_car/pages/autenticacao/auth_page.dart';
import 'package:auto_car/pages/autenticacao/login_main_page.dart';
import 'package:auto_car/pages/products_form_page.dart';
import 'package:auto_car/pages/products_page.dart';
import 'package:auto_car/pages/produtos_car_screen.dart';
import 'package:auto_car/utils/app_routes.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

//import 'package:firebase_core/firebase_core.dart';
void main() async {
  // runApp(const MyApp());
  runApp(
    ChangeNotifierProvider(
      create: (context) => ValueNotifier<String>(''),
      child: const MyApp(),
    ),
  );
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
        ChangeNotifierProxyProvider<Auth, CarList>(
          create: (_) => CarList(),
          update: (ctx, auth, previous) {
            return CarList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProvider(
          create: (_) => Carrinho(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            primary: const Color(0xFF003BDF),
            secondary: Colors.white,
            seedColor: const Color.fromARGB(255, 0, 0, 0),
          ),
          primaryIconTheme: const IconThemeData(color: Colors.white),
          iconTheme: const IconThemeData(
            color: Colors.white, // Cor do ícone de menu suspenso (more_vert)
          ),
          //useMaterial3: true,
        ),
        //home: const PageLogin(),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.HOME: (ctx) => const SplashScreen(),
          //AppRoutes.HOME: (ctx) => const ProductCarPage(),

          //AppRoutes.LOGIN_MAIN_PAGE: (ctx) => const AuthPage(),

          AppRoutes.LOGIN_MAIN_PAGE: (ctx) => const LoginMainPage(),
          AppRoutes.AUTHPAGE: (ctx) => const AuthPage(),
          //AppRoutes.CADASTRO_PAGE: (ctx) => const CadastroPage(),
          AppRoutes.PROUCT_CAR: (ctx) => const ProductCarPage(),
          AppRoutes.FAVORITES: (ctx) => const FavoritePage(),
          AppRoutes.CART: (ctx) => const CarrinhoPage(),
          AppRoutes.PRODUCTS: (ctx) => const ProductsPage(),
          AppRoutes.PRODUCTFORM: (ctx) => const ProductFormPage(),
        },
      ),
    );
  }
}
