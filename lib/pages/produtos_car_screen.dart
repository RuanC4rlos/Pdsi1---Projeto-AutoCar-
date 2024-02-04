// import 'dart:async';
// import 'package:auto_car/components/bottom_navigation_bar.dart';
// import 'package:auto_car/models/auth.dart';
// import 'package:auto_car/models/car.dart';
// import 'package:auto_car/models/car_list.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:auto_car/components/app_drawer.dart';
// import 'package:auto_car/components/product_item.dart';
// import 'package:provider/provider.dart';

// import 'package:rxdart/rxdart.dart';

// class ProductCarPage extends StatefulWidget {
//   const ProductCarPage({Key? key}) : super(key: key);

//   @override
//   State<ProductCarPage> createState() => _ProductCarPageState();
// }

// class _ProductCarPageState extends State<ProductCarPage> {
//   bool _isLoading = true;
//   List<Reference> refs = [];
//   List<String> arquivos = [];
//   // final StreamController<String> _searchController = StreamController<String>();
//   final _searchController = BehaviorSubject<String>();
//   final FirebaseStorage storage = FirebaseStorage.instance;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> loadImages(List<String> userIds, String nomeCar) async {
//     for (String userId in userIds) {
//       refs = (await storage.ref('$userId/$nomeCar').listAll()).items;
//       for (var ref in refs) {
//         final arquivo = await ref.getDownloadURL();
//         arquivos.add(arquivo);
//       }
//     }
//     setState(() {});
//   }

//   Future<void> _loadData() async {
//     await Provider.of<CarList>(
//       context,
//       listen: false,
//     ).loadProducts();
//     setState(() {
//       _isLoading = false;
//     });
//     // ignore: use_build_context_synchronously
//     String userId = Provider.of<Auth>(context, listen: false) as String;

//     // ignore: use_build_context_synchronously
//     String nomeCar = Provider.of<Car>(context, listen: false) as String;
//     arquivos = loadImages(userId as List<String>, nomeCar) as List<String>;
//   }

//   @override
//   void dispose() {
//     _searchController.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final loadedProducts = Provider.of<CarList>(context).items;

//     return Scaffold(
//       appBar: AppBar(
//         title: Container(
//           padding: const EdgeInsets.only(left: 45),
//           child: Image.asset(
//             'assets/images/logo.png',
//             height: 35,
//             color: Theme.of(context).colorScheme.secondary,
//           ),
//         ),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10),
//                   child: SizedBox(
//                     width: 340,
//                     height: 60,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: TextField(
//                         onChanged: (value) {
//                           _searchController.add(value);
//                         },
//                         decoration: InputDecoration(
//                           labelText: 'Pesquise por uma marca',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(25.0),
//                           ),
//                           prefixIcon: const Icon(Icons.search),
//                           filled: true,
//                           fillColor: Colors.white70,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: StreamBuilder<String>(
//                     stream: _searchController.stream
//                         .debounceTime(const Duration(milliseconds: 300)),
//                     builder: (ctx, snapshot) {
//                       final searchValue = snapshot.data ?? '';

//                       final filteredProducts = loadedProducts.where((product) {
//                         return product.marca
//                             .toLowerCase()
//                             .contains(searchValue.toLowerCase());
//                       }).toList();
//                       return GridView.builder(
//                         padding: const EdgeInsets.all(10),
//                         itemCount: filteredProducts.length,
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           childAspectRatio: 3 / 4,
//                           crossAxisSpacing: 10,
//                           mainAxisSpacing: 10,
//                         ),
//                         itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
//                           value: filteredProducts[i],
//                           child: const ProductItem(),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//       drawer: const AppDrawer(),
//       bottomNavigationBar: CustomBottomNavigationBar(
//         selectedItem: NavigationItem(Icons.home),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:auto_car/components/bottom_navigation_bar.dart';
import 'package:auto_car/models/auth.dart';
import 'package:auto_car/models/car.dart';
import 'package:auto_car/models/car_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:auto_car/components/app_drawer.dart';
import 'package:auto_car/components/product_item.dart';
import 'package:provider/provider.dart';

// ignore: depend_on_referenced_packages, unused_import
import 'package:rxdart/rxdart.dart';

class ProductCarPage extends StatefulWidget {
  const ProductCarPage({Key? key}) : super(key: key);

  @override
  State<ProductCarPage> createState() => _ProductCarPageState();
}

class _ProductCarPageState extends State<ProductCarPage> {
  bool _isLoading = true;
  List<Reference> refs = [];
  List<String> arquivos = [];
  // final StreamController<String> _searchController = StreamController<String>();
  //final _searchController = BehaviorSubject<String>();
  final FirebaseStorage storage = FirebaseStorage.instance;
  final _searchController = TextEditingController();
  String _searchValue = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadData();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchValue = _searchController.text;
    });
  }

  Future<void> loadImages(List<String> userIds, String nomeCar) async {
    for (String userId in userIds) {
      refs = (await storage.ref('$userId/$nomeCar').listAll()).items;
      for (var ref in refs) {
        final arquivo = await ref.getDownloadURL();
        arquivos.add(arquivo);
      }
    }
    setState(() {});
  }

  Future<void> _loadData() async {
    final product = Provider.of<CarList>(
      context,
      listen: false,
    );
    setState(() {
      _isLoading = false;
    });
    product.loadProducts();
    product.loadProductsAlugados();
    setState(() {
      _isLoading = false;
    });
    // ignore: use_build_context_synchronously
    String userId = Provider.of<Auth>(context, listen: false) as String;

    // ignore: use_build_context_synchronously
    String nomeCar = Provider.of<Car>(context, listen: false) as String;
    arquivos = loadImages(userId as List<String>, nomeCar) as List<String>;
  }

  @override
  Widget build(BuildContext context) {
    final loadedProducts = Provider.of<CarList>(context).allItems;
    final filteredProducts = loadedProducts.where((product) {
      return product.marca.toLowerCase().contains(_searchValue.toLowerCase());
    }).toList();

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
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    width: 340,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Pesquise por uma marca',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: filteredProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                      value: filteredProducts[i],
                      child: const ProductItem(),
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
