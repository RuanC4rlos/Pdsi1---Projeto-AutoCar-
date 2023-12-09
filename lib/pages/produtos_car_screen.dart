// ignore_for_file: depend_on_referenced_packages

import 'package:auto_car/pages/favorite_page.dart';
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

class NavigationItem {
  IconData iconData;

  NavigationItem(this.iconData);
}

class _ProductCarPageState extends State<ProductCarPage> {
  final List<Car> loadedProducts = dummyProducts;

  List<NavigationItem> getNavigationItemList() {
    return <NavigationItem>[
      NavigationItem(Icons.home),
      NavigationItem(Icons.search),
      NavigationItem(Icons.favorite),
      NavigationItem(Icons.shopping_cart),
    ];
  }

  late List<NavigationItem> navigationItems = getNavigationItemList();
  late NavigationItem selectedItem;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedItem = navigationItems[0];
    });
  }

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
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: buildNavigationItems(),
        ),
      ),
    );
  }

  List<Widget> buildNavigationItems() {
    List<Widget> list = [];
    for (var navigationItem in navigationItems) {
      list.add(buildNavigationItem(navigationItem));
    }
    return list;
  }

  Widget buildNavigationItem(NavigationItem item) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          selectedItem = item;
        });

        if (item.iconData == Icons.home) {
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProductCarPage()),
          );
        } else if (item.iconData == Icons.search) {
          await Navigator.pushNamed(context, '/search');
        } else if (item.iconData == Icons.favorite) {
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const FavoritePage()),
          );
        } else if (item.iconData == Icons.shopping_cart) {
          await Navigator.pushNamed(context, '/cart');
        }
      },
      child: SizedBox(
        width: 50,
        child: Stack(
          children: <Widget>[
            selectedItem == item
                ? Center(
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF1EBFF),
                      ),
                    ),
                  )
                : Container(),
            Center(
              child: Icon(
                item.iconData,
                color: selectedItem == item
                    ? const Color(0xFF003BDF)
                    : Colors.grey[400],
                size: 24,
              ),
            )
          ],
        ),
      ),
    );
  }
}
