import 'package:auto_car/components/app_drawer.dart';
import 'package:auto_car/components/bottom_navigation_bar.dart';
import 'package:auto_car/components/product_gerenciar_item.dart';
import 'package:auto_car/models/car_list.dart';
import 'package:auto_car/utils/app_routes.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _refreshUserProducts(context);
  }

  Future<void> _refreshUserProducts(BuildContext context) {
    setState(() {
      _isLoading = true;
    });

    return Provider.of<CarList>(
      context,
      listen: false,
    ).loadUserProducts().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<CarList>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Carros'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.PRODUCTFORM);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => _refreshUserProducts(context),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: products.userItems.length,
                  itemBuilder: (ctx, i) =>
                      ProductGerenciarItem(product: products.userItems[i]),
                ),
              ),
            ),
      bottomNavigationBar:
          CustomBottomNavigationBar(selectedItem: NavigationItem(Icons.abc)),
    );
  }
}
