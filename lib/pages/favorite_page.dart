// ignore_for_file: depend_on_referenced_packages
import 'package:auto_car/components/product_item.dart';
import 'package:auto_car/models/car_list.dart';
import 'package:auto_car/pages/produtos_car_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class NavigationItem {
  IconData iconData;

  NavigationItem(this.iconData);
}

class _FavoritePageState extends State<FavoritePage> {
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
      selectedItem = navigationItems[2];
    });
  }

  @override
  Widget build(BuildContext context) {
    final carList = Provider.of<CarList>(context, listen: false);
    final favoriteItems =
        carList.items.where((carItem) => carItem.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
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
