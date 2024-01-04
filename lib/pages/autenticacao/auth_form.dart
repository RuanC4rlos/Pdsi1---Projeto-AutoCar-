import 'package:auto_car/exceptions/auth_exception.dart';
import 'package:auto_car/models/auth.dart';
import 'package:auto_car/utils/app_routes.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  final ValueChanged<AuthMode> onAuthModeChange;
  final AuthMode initialAuthMode;
  const AuthForm(
      {required this.initialAuthMode, required this.onAuthModeChange, Key? key})
      : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  late AuthMode _authMode;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  final _emailFocusNode = FocusNode(); // Add a focus node for the email field
  final _passwordFocusNode =
      FocusNode(); // Add a focus node for the password field

  AnimationController? _controller;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _slideAnimation;

  bool _isLogin() => _authMode == AuthMode.login;
  Auth modo = Auth();
  @override
  void initState() {
    super.initState();
    _authMode = widget.initialAuthMode;
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

    // _heightAnimation?.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  void _switchAuthMode() {
    setState(() {
      if (_authMode == AuthMode.login) {
        _authMode = AuthMode.signup;
        _controller?.forward();
      } else {
        _authMode = AuthMode.login;

        _controller?.reverse();
      }
      widget.onAuthModeChange.call(_authMode);
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreo um Erro'),
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
    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        // Login
        await auth.login(
          _authData['email']!,
          _authData['password']!,
        );
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, AppRoutes.PROUCT_CAR);
      } else {
        // Registrar
        await auth.signup(
          _authData['email']!,
          _authData['password']!,
        );
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, AppRoutes.PROUCT_CAR);
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
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
          height: _isLogin() ? 340 : 430,
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
                  constraints: BoxConstraints(
                    minHeight: _isLogin() ? 0 : 60,
                    maxHeight: _isLogin() ? 0 : 120,
                  ),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear,
                  child: FadeTransition(
                    opacity: _opacityAnimation!,
                    child: SlideTransition(
                      position: _slideAnimation!,
                      child: TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Confirmar Senha'),
                        keyboardType: TextInputType.emailAddress,
                        obscureText: true,
                        validator: _isLogin()
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
                      child: Text(
                        _authMode == AuthMode.login ? 'ENTRAR' : 'REGISTRAR',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                    _isLogin() ? 'DESEJA REGISTRAR?' : 'JÁ POSSUI CONTA?',
                    style: const TextStyle(
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
