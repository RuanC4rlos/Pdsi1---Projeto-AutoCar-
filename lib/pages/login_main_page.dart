import 'package:auto_car/pages/cadastro/cadastro_page.dart';
import 'package:auto_car/pages/login/login_page.dart';
import 'package:flutter/material.dart';

class LoginMainPage extends StatefulWidget {
  const LoginMainPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginMainPageState createState() => _LoginMainPageState();
}

class _LoginMainPageState extends State<LoginMainPage> {
  Color entrarButtonColor = const Color(0xFF003BDF);
  Color entrarTextColor = Colors.white;

  Color cadastroButtonColor = const Color(0xFF003BDF);
  Color cadastroTextColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    double containerWidth = MediaQuery.of(context).size.width;
    double containerHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Image.asset(
              'assets/images/logo.png',
              height: 50,
              color: const Color(0xFF003BDF),
            ),
            const SizedBox(height: 40),
            Image.asset(
              'assets/images/img1.png',
              height: 170,
            ),
            const SizedBox(height: 40),
            const Text(
              'Bem vindo(a)!',
              style: TextStyle(
                  color: Color(0xFF003BDF),
                  fontSize: 25,
                  fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: containerWidth * 1,
                    height: containerHeight * 0.4534,
                    decoration: const BoxDecoration(
                      color: Color(0xFF003BDF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32.0),
                        topRight: Radius.circular(32.0),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 70),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()));
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: entrarTextColor,
                                backgroundColor: entrarButtonColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 116, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(color: Colors.white),
                                ),
                              ),
                              child: const Text(
                                'Entrar',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(height: 40),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CadastroPage()));
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: cadastroTextColor,
                                backgroundColor: cadastroButtonColor,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 100, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(color: Colors.white),
                                ),
                              ),
                              child: const Text(
                                'Cadastro',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
