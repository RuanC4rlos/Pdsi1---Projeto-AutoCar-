import 'package:auto_car/pages/favorite_page.dart';
import 'package:auto_car/pages/produtos_car_screen.dart';
import 'package:flutter/material.dart';

class NavigationItem {
  IconData iconData;

  NavigationItem(this.iconData);
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
          await Navigator.pushNamed(context, '/search');
        } else if (item.iconData == Icons.favorite) {
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const FavoritePage()),
          );
        } else if (item.iconData == Icons.shopping_cart) {
          await Navigator.pushNamed(context, '/cart');
        }
        setState(() {
          widget.selectedItem = item;
        });
      },
      child: SizedBox(
        width: 50,
        child: Stack(
          children: <Widget>[
            widget.selectedItem == item
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
                color: widget.selectedItem == item
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
