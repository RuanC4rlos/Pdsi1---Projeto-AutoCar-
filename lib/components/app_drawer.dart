import 'package:auto_car/models/auth.dart';
import 'package:auto_car/utils/app_routes.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    //FirebaseAuth auth = FirebaseAuth.instance;
    return Drawer(
      child: Column(
        children: [
          AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bem Vindo',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  Text(
                    auth.email ?? '',
                    style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ],
              )),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.car_crash),
            title: const Text('Vender meu carro'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.PRODUCTS);
            },
          ),
          const Divider(color: Colors.black),
          ListTile(
            leading: const Icon(Icons.car_rental),
            title: const Text('Aluguar meu veiculo'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.RESERVAR_CAR);
            },
          ),
          const Divider(color: Colors.black),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Pedidos'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.ORDERS);
            },
          ),
          const Divider(color: Colors.black),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () => {
              Provider.of<Auth>(context, listen: false).logout(),
              Navigator.pushReplacementNamed(context, AppRoutes.LOGIN_MAIN_PAGE)
            },
            //Navigator.of(context).pushReplacementNamed(AppRoutes.AUTH_OR_HOME,)
          ),
          const Divider(color: Colors.black),
        ],
      ),
    );
  }

// ...
}
