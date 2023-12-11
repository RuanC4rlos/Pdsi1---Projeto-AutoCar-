// import 'package:auto_car/components/badgee.dart';
// import 'package:auto_car/models/carrinho.dart';
// import 'package:auto_car/pages/favorite_page.dart';
// import 'package:auto_car/pages/produtos_car_screen.dart';
// import 'package:flutter/material.dart';
// // ignore: depend_on_referenced_packages
// import 'package:provider/provider.dart';

// class NavigationItem {
//   IconData iconData;

//   NavigationItem(this.iconData);
// }

// // ignore: must_be_immutable
// class TesteeeBottomNavigationBar extends StatefulWidget {
//   late NavigationItem selectedItem;

//   TesteeeBottomNavigationBar({Key? key, required this.selectedItem})
//       : super(key: key);

//   @override
//   // ignore: library_private_types_in_public_api
//   _TesteeeBottomNavigationBarState createState() =>
//       // ignore: no_logic_in_create_state
//       _TesteeeBottomNavigationBarState(selectedItem);
// }

// class _TesteeeBottomNavigationBarState
//     extends State<TesteeeBottomNavigationBar> {
//   late NavigationItem selectedItem; // Declare selectedItem here

//   _TesteeeBottomNavigationBarState(NavigationItem selectedItem) {
//     this.selectedItem =
//         selectedItem; // Initialize selectedItem in the constructor
//   }

//   List<NavigationItem> getNavigationItemList() {
//     return <NavigationItem>[
//       NavigationItem(Icons.home),
//       NavigationItem(Icons.search),
//       NavigationItem(Icons.favorite),
//       NavigationItem(Icons.shopping_cart),
//     ];
//   }

//   late List<NavigationItem> navigationItems = getNavigationItemList();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 70,
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.secondary,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(30),
//           topRight: Radius.circular(30),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: buildNavigationItems(),
//       ),
//     );
//   }

//   List<Widget> buildNavigationItems() {
//     List<Widget> list = [];
//     for (var navigationItem in navigationItems) {
//       list.add(buildNavigationItem(navigationItem));
//     }
//     return list;
//   }

//   Widget buildNavigationItem(NavigationItem item) {
//     return GestureDetector(
//       onTap: () async {
//         setState(() {
//           widget.selectedItem = item;
//         });
//         if (item.iconData == Icons.home) {
//           await Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const ProductCarPage()),
//           );
//         } else if (item.iconData == Icons.search) {
//           await Navigator.pushNamed(context, '/search');
//         } else if (item.iconData == Icons.favorite) {
//           await Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const FavoritePage()),
//           );
//         } else if (item.iconData == Icons.shopping_cart) {
//           await Navigator.pushNamed(context, '/cart');
//         }
//       },
//       child: SizedBox(
//         width: 50,
//         child: Stack(
//           children: <Widget>[
//             selectedItem == item
//                 ? Center(
//                     child: Container(
//                       height: 50,
//                       width: 50,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: widget.selectedItem == item
//                             ? const Color(0xFFF1EBFF)
//                             : Colors.transparent,
//                         // border: Border.all(
//                         //   color: widget.selectedItem == item
//                         //       ? const Color(0xFF003BDF)
//                         //       : Colors.grey[400],
//                         // ),
//                       ),
//                     ),
//                   )
//                 : Container(),
//             Center(
//               child: Icon(
//                 item.iconData,
//                 // ignore: unrelated_type_equality_checks

//                 color: Icons.home == item.iconData
//                     ? const Color(0xFF003BDF)
//                     : Colors.grey[400],
//                 size: 24,
//               ),
//             ),
//             Consumer<Carrinho>(
//               builder: (ctx, cart, child) =>
//                   cart.itemsCount > 0 && item.iconData == Icons.shopping_cart
//                       ? Badgee(
//                           value: cart.itemsCount.toString(),
//                           child: Center(
//                             child: Icon(
//                               item.iconData,
//                               // ignore: unrelated_type_equality_checks
//                               color: item.iconData == item
//                                   ? const Color(0xFF003BDF)
//                                   : Colors.grey[400],
//                               size: 24,
//                             ),
//                           ),
//                         )
//                       : Center(
//                           child: Icon(
//                             item.iconData,
//                             // ignore: unrelated_type_equality_checks
//                             color: item.iconData == item
//                                 ? const Color(0xFF003BDF)
//                                 : Colors.grey[400],
//                             size: 24,
//                           ),
//                         ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
