// ignore_for_file: depend_on_referenced_packages

import 'package:auto_car/components/badgee.dart';
import 'package:auto_car/models/carrinho.dart';
import 'package:auto_car/pages/carrinho_page.dart';
import 'package:auto_car/pages/favoritos/favorite_page.dart';
import 'package:auto_car/pages/produtos_car_screen.dart';
import 'package:auto_car/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationItem {
  IconData iconData;

  NavigationItem(this.iconData);
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NavigationItem && other.iconData == iconData;
  }

  @override
  int get hashCode => iconData.hashCode;
}

// ignore: must_be_immutable
class CustomBottomNavigationBar extends StatefulWidget {
  late NavigationItem selectedItem;

  CustomBottomNavigationBar({super.key, required this.selectedItem});

  @override
  // ignore: library_private_types_in_public_api
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  List<NavigationItem> getNavigationItemList() {
    return <NavigationItem>[
      NavigationItem(Icons.home),
      NavigationItem(Icons.search),
      NavigationItem(Icons.favorite),
      NavigationItem(Icons.shopping_cart),
    ];
  }

  late List<NavigationItem> navigationItems = getNavigationItemList();

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }

  List<Widget> buildNavigationItems() {
    //return navigationItems.map(buildNavigationItem).toList();
    List<Widget> list = [];
    for (var navigationItem in navigationItems) {
      list.add(buildNavigationItem(navigationItem));
    }
    return list;
  }

  Widget buildNavigationItem(NavigationItem item) {
    return GestureDetector(
      onTap: () async {
        if (item.iconData == Icons.home) {
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProductCarPage()),
          );
        } else if (item.iconData == Icons.search) {
          await Navigator.of(context).pushNamed(AppRoutes.SEARCH);
        } else if (item.iconData == Icons.favorite) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => const FavoritePage(),
            ),
          );
          //await Navigator.of(context).pushReplacementNamed(AppRoutes.FAVORITES);
        } else if (item.iconData == Icons.shopping_cart) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => const CarrinhoPage(),
            ),
          );
          //await Navigator.of(context).pushReplacementNamed(AppRoutes.CART);
        }

        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFF1EBFF),
          ),
        );
      },
      child: SizedBox(
        width: 50,
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.selectedItem == item
                      ? const Color.fromARGB(255, 210, 210, 221)
                      : Colors.transparent,
                ),
              ),
            ),
            Center(
              child: Icon(
                item.iconData,
                color: widget.selectedItem == item
                    ? const Color(0xFF003BDF)
                    : Colors.grey[400],
                size: 24,
              ),
            ),
            Consumer<Carrinho>(
                builder: (ctx, cart, child) =>
                    cart.itemsCount > 0 && item.iconData == Icons.shopping_cart
                        ? Badgee(
                            value: cart.itemsCount.toString(),
                            child: Center(
                              child: Icon(
                                item.iconData,
                                color: widget.selectedItem == item
                                    ? const Color(0xFF003BDF)
                                    : Colors.grey[400],
                                size: 24,
                              ),
                            ),
                          )
                        : Container()),
            Center(
              child: Icon(
                item.iconData,
                color: item == widget.selectedItem
                    ? const Color(0xFF003BDF)
                    : Colors.grey[400],
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
