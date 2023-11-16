import 'package:auto_car/pages/cadastro/form_cadastro.dart';
import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003BDF),
      body: Center(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: SizedBox(
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
                          'Cadastrar',
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
                          'Insira seu e-mail e senha para criar seu cadastro. ',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    const FormCadastro(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
