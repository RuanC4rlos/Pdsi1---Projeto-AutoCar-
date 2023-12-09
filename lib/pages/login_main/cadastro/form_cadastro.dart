import 'package:auto_car/exceptions/auth_exception.dart';
import 'package:auto_car/models/auth.dart';
import 'package:auto_car/utils/app_routes.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

//enum AuthMode { signup, login }

class FormCadastro extends StatefulWidget {
  const FormCadastro({Key? key}) : super(key: key);

  @override
  State<FormCadastro> createState() => _FormCadastroState();
}

class _FormCadastroState extends State<FormCadastro>
    with SingleTickerProviderStateMixin {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _emailFocusNode = FocusNode(); // Add a focus node for the email field
  final _passwordFocusNode =
      FocusNode(); // Add a focus node for the password field

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  final bool _isLogin = false;

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um Erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    //Auth auth = Provider.of(context, listen: false);

    Auth auth = Provider.of<Auth>(context, listen: false);

    try {
      if (!_isLogin) {
        // Registrar
        await auth.signup(
          _authData['email']!,
          _authData['password']!,
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }

    setState(() => _isLoading = false);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, AppRoutes.LOGIN_PAGE);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        padding: const EdgeInsets.all(16),
        height: 425,
        width: deviceSize.width * 0.75,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                alignment: Alignment.topRight,
                width: 400,
                height: 25,
                child: IconButton(
                  color: Colors.black,
                  icon: const Icon(Icons.close),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    await Future.delayed(const Duration(milliseconds: 450));

                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.LOGIN_MAIN_PAGE);
                  },
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                focusNode: _emailFocusNode,
                // ignore: no_leading_underscores_for_local_identifiers
                validator: (_email) {
                  final email = _email ?? '';
                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Informe um e-mail válido.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                controller: _passwordController,
                onSaved: (password) => _authData['password'] = password ?? '',
                focusNode: _passwordFocusNode,

                // ignore: no_leading_underscores_for_local_identifiers
                validator: (_password) {
                  final password = _password ?? '';
                  if (password.isEmpty || password.length < 5) {
                    return 'Informe uma senha válida';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Confirmar Senha'),
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                validator: _isLogin
                    ? null
                    // ignore: no_leading_underscores_for_local_identifiers
                    : (_password) {
                        final password = _password ?? '';
                        if (password != _passwordController.text) {
                          return 'Senhas informadas não conferem.';
                        }
                        return null;
                      },
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                //Color.fromRGBO(0, 59, 223, 1),
                //Color.fromRGBO(210, 32, 255, 1)
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromRGBO(210, 32, 255, 1),
                        Color.fromRGBO(0, 59, 223, 1),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation:
                          0, // Define a elevação para 0 para evitar a sombra padrão
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 8,
                      ),
                    ),
                    child: const Text(
                      'REGISTRAR',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.LOGIN_PAGE);
                },
                child: const Text(
                  'JÁ POSSUI CONTA?',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Color(0xFF7033FF)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
