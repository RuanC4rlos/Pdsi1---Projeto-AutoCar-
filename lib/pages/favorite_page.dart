// ignore_for_file: depend_on_referenced_packages
import 'package:auto_car/components/bottom_navigation_bar.dart';
import 'package:auto_car/components/product_item.dart';
import 'package:auto_car/models/car_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    final carList = Provider.of<CarList>(context, listen: false);
    final favoriteItems =
        carList.items.where((carItem) => carItem.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFF003BDF),
          title: const Text(
            'Favoritos',
            style: TextStyle(color: Colors.white, fontSize: 26),
          )),
      body: favoriteItems.isEmpty
          ? const Center(
              child: Text('Nenhum item foi adicionado aos favoritos.'))
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: favoriteItems.length,
              itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                value: favoriteItems[i],
                child: const ProductItem(),
              ),
            ),
      bottomNavigationBar: CustomBottomNavigationBar(
          selectedItem: NavigationItem(Icons.favorite)),
    );
  }
}
