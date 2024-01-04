import 'package:auto_car/pages/autenticacao/auth_form.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late AuthMode _authMode = AuthMode.login;
  void _handleAuthModeChange(AuthMode authMode) {
    setState(() {
      _authMode = authMode;
    });
  }

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
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 55), // Espaço à esquerda
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _authMode == AuthMode.login
                            ? const Text(
                                'Acesso',
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white),
                              )
                            : const Text(
                                'Cadastro',
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 55, bottom: 15, top: 10), // Espaço à esquerda
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _authMode == AuthMode.login
                            ? const Text(
                                'Insira seu e-mail e senha para fazer o login.',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              )
                            : const Text(
                                'Insira seu e-mail e senha para criar seu cadastro. ',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                      ),
                    ),
                    AuthForm(
                      onAuthModeChange: _handleAuthModeChange,
                      initialAuthMode: _authMode,
                    ),
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
