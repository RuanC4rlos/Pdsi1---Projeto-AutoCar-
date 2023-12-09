import 'package:auto_car/pages/login_main/login/form_login.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003BDF),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 55),
        child: Center(
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 50,
                        color: Colors.white,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 55), // Espaço à esquerda
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Acesso',
                          style: TextStyle(fontSize: 25, color: Colors.white),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 55, bottom: 15, top: 10), // Espaço à esquerda
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Insira seu e-mail e senha para fazer o login.',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    const FormLogin(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
