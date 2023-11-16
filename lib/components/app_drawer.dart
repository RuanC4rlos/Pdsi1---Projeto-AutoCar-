import 'package:auto_car/utils/app_routes.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    //FirebaseAuth auth = FirebaseAuth.instance;
    return Drawer(
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              //auth.currentUser!.email ??
              'Bem Vindo', style: TextStyle(color: Colors.black),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Vender Carro'),
            onTap: () {
              //Navigator.of(context).pushReplacementNamed(AppRoutes.AUTH_OR_HOME,)
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Aluguar Carro'),
            onTap: () {
              //Navigator.of(context).pushReplacementNamed(AppRoutes.AUTH_OR_HOME,)
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () => {
              Navigator.pushReplacementNamed(context, AppRoutes.LOGIN_MAIN_PAGE)

              //   Navigator.of(context)
              //       .pushReplacementNamed(AppRoutes.AUTH_OR_HOME),
            },
            //Navigator.of(context).pushReplacementNamed(AppRoutes.AUTH_OR_HOME,)
          ),
        ],
      ),
    );
  }

// ...
}
