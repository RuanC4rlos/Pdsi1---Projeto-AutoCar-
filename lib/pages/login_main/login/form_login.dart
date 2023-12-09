import 'package:auto_car/pages/produtos_car_screen.dart';
import 'package:auto_car/utils/app_routes.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../../../exceptions/auth_exception.dart';
import '../../../models/auth.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({Key? key}) : super(key: key);

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin>
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

  AnimationController? _controller;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );

    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.linear,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.linear,
      ),
    );
  }

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

    Auth auth = Provider.of<Auth>(context, listen: false);

    try {
      // Login
      await auth.login(
        _authData['email']!,
        _authData['password']!,
      );
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ProductCarPage()));
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Email ou senha incorretos!');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
          padding: const EdgeInsets.all(16),
          height: 355,
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
                AnimatedContainer(
                  constraints: const BoxConstraints(
                    minHeight: 0,
                    maxHeight: 0,
                  ),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear,
                  child: FadeTransition(
                    opacity: _opacityAnimation!,
                    child: SlideTransition(
                      position: _slideAnimation!,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
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
                        'Entrar',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                        context, AppRoutes.CADASTRO_PAGE);
                  },
                  child: const Text(
                    'DESEJA REGISTRAR?',
                    style: TextStyle(
                        fontWeight: FontWeight.w700, color: Color(0xFF7033FF)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
