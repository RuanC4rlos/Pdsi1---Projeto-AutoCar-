// ignore_for_file: depend_on_referenced_packages
import 'dart:async';

import 'package:auto_car/components/bottom_navigation_bar.dart';
import 'package:auto_car/models/car_list.dart';
import 'package:flutter/material.dart';
import 'package:auto_car/components/app_drawer.dart';
import 'package:auto_car/components/product_item.dart';
import 'package:auto_car/components/search.dart';
import 'package:provider/provider.dart';

class ProductCarPage extends StatefulWidget {
  const ProductCarPage({Key? key}) : super(key: key);

  @override
  State<ProductCarPage> createState() => _ProductCarPageState();
}

class _ProductCarPageState extends State<ProductCarPage> {
  bool _isLoading = true;
  final StreamController<String> _searchController =
      StreamController<String>.broadcast();

  @override
  void initState() {
    super.initState();
    Provider.of<CarList>(
      context,
      listen: false,
    ).loadProducts().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final loadedProducts = Provider.of<CarList>(context).items;

    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.only(left: 45),
          child: Image.asset(
            'assets/images/logo.png',
            height: 35,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Search(searchController: _searchController),
                Expanded(
                  child: StreamBuilder<String>(
                    stream: _searchController.stream,
                    builder: (ctx, snapshot) {
                      final searchValue = snapshot.data ?? '';
                      final filteredProducts = loadedProducts.where((product) {
                        return product.marca
                            .toLowerCase()
                            .contains(searchValue.toLowerCase());
                      }).toList();

                      return ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: filteredProducts.length,
                        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                          value: filteredProducts[i],
                          child: const ProductItem(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      drawer: const AppDrawer(),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedItem: NavigationItem(Icons.home),
      ),
    );
  }
}
