import 'package:auto_car/components/app_drawer.dart';
import 'package:auto_car/components/bottom_navigation_bar.dart';
import 'package:auto_car/components/order.dart';
import 'package:auto_car/components/order_alugados.dart';
import 'package:auto_car/models/car_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order_list.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late bool _isLoading = true;
  late bool _showPurchased = true; // Adicione esta linha

  Future<void> loadData() async {
    final CarList product = Provider.of(context, listen: false);
    await product.loadReserva();
  }

  @override
  void initState() {
    super.initState();

    loadData();
    Provider.of<OrderList>(
      context,
      listen: false,
    ).loadOrders().then((_) {
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of(context, listen: false);
    final CarList reservados = Provider.of(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
        actions: <Widget>[
          // Adicione esta seção
          ElevatedButton.icon(
            icon: Icon(_showPurchased ? Icons.shopping_cart : Icons.car_rental,
                color: Colors.white),
            label: Text(_showPurchased ? 'Comprados' : 'Alugados',
                style: const TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: _showPurchased
                  ? Colors.green
                  : Colors.blue, // Altere as cores aqui
              elevation: 0,
            ),
            onPressed: () {
              setState(() {
                _showPurchased = !_showPurchased;
              });
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.itemsCount == 0
              ? const Center(
                  child: SizedBox(
                    child: Text('Nenhum pedido foi adicionado!'),
                  ),
                )
              : _showPurchased
                  ? ListView.builder(
                      itemCount: orders.itemsCount,
                      itemBuilder: (ctx, i) =>
                          OrderWidget(order: orders.items[i]),
                    )
                  : //Container(),
                  ListView.builder(
                      itemCount: reservados.itemsCountReservados,
                      itemBuilder: (ctx, i) =>
                          OrderAlugados(order: reservados.itemsReservados[i]),
                    ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedItem: NavigationItem(Icons.abc),
      ),
    );
  }
}
