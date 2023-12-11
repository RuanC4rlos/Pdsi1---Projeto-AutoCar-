// ignore_for_file: depend_on_referenced_packages
import 'package:auto_car/components/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:auto_car/components/app_drawer.dart';
import 'package:auto_car/components/product_item.dart';
import 'package:auto_car/components/search.dart';
import 'package:auto_car/data/dummy_data.dart';
import 'package:auto_car/models/car.dart';
import 'package:provider/provider.dart';

class ProductCarPage extends StatefulWidget {
  const ProductCarPage({Key? key}) : super(key: key);

  @override
  State<ProductCarPage> createState() => _ProductCarPageState();
}

class _ProductCarPageState extends State<ProductCarPage> {
  final List<Car> loadedProducts = dummyProducts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.only(left: 45),
          child: Image.asset(
            'assets/images/logo.png',
            height: 35,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF003BDF),
        //Theme.of(context).colorScheme.secondary,
      ),
      body: Column(
        children: [
          // Adicionando o componente Search
          const Search(),
          // Adicionando a lista de produtos
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: loadedProducts.length,
                itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                  value: loadedProducts[i],
                  child: const ProductItem(),
                ),
              ),
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
