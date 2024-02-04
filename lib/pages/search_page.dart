// ignore_for_file: depend_on_referenced_packages
import 'package:auto_car/components/app_drawer.dart';
import 'package:auto_car/components/bottom_navigation_bar.dart';
import 'package:auto_car/models/car.dart';
import 'package:auto_car/models/car_list.dart';
import 'package:flutter/material.dart';
import 'package:auto_car/components/product_item.dart';
import 'package:auto_car/components/search.dart';
import 'package:provider/provider.dart';

import 'package:rxdart/rxdart.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _isLoading = true;
  //final StreamController<String> _searchController =
  //  StreamController<String>.broadcast();
  late String searchValue = '';
  final _searchController = BehaviorSubject<String>();

  late RangeValues _priceRange = const RangeValues(0, 100000);
  late String _estado = 'Selecione';
  late int _ano = 2000;
  late int _km = 0;
  late String _cor = '';
  late String _opcao = 'Selecione';
  bool filt = false;

  bool _isFiltered = false;
  @override
  void initState() {
    super.initState();
    final product = Provider.of<CarList>(
      context,
      listen: false,
    );
    product.loadProductsAlugados();
    product.loadProducts().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _searchController.close();
    super.dispose();
  }

  void resetFilters() {
    _priceRange = const RangeValues(0.0, 100000.0);
    _estado = 'Selecione';
    _ano = 2000;
    _km = 0;
    _cor = '';
    _opcao = 'Selecione';
  }

  @override
  Widget build(BuildContext context) {
    var loadedProducts = Provider.of<CarList>(context).allItems;
    var filteredProducts = [];
    return Scaffold(
      appBar: filt
          ? null
          : AppBar(
              centerTitle: true,
              title: const Text(
                'Pesquisar',
                style: TextStyle(fontSize: 28),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                filt
                    ? const Padding(padding: EdgeInsets.only(top: 50))
                    : const Padding(padding: EdgeInsets.all(0)),
                Search(
                  searchController: _searchController,
                  selected: Icons.filter_list,
                  onFiltersChanged: (RangeValues priceRange, String estado,
                      int ano, int km, String cor, String opcao) {
                    setState(() {
                      resetFilters();
                      _priceRange = priceRange;
                      _estado = estado;
                      _ano = ano;
                      _km = km;
                      _cor = cor;
                      _isFiltered = true;
                      filteredProducts = [];
                      filt = true;
                      _opcao = opcao;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          filt = !filt;
                          _isFiltered = !_isFiltered;
                          resetFilters();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          shadowColor: Colors.black,
                          backgroundColor: Colors.white,
                          side: filt
                              ? BorderSide(
                                  width: 1,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : null),
                      child: Text(
                        'All',
                        style: TextStyle(
                            color: filt
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
                //********************************************** */
                Expanded(
                  child: StreamBuilder<String>(
                    stream: _searchController.stream
                        .debounceTime(const Duration(milliseconds: 500)),
                    builder: (ctx, snapshot) {
                      final searchValue = snapshot.data ?? '';

                      filteredProducts = _isFiltered
                          ? loadedProducts.where((product) {
                              final isMatchingSearchValue =
                                  searchValue.isEmpty ||
                                      product.marca
                                          .toLowerCase()
                                          .contains(searchValue.toLowerCase());
                              final isWithinPriceRange =
                                  (_priceRange.end != 100000.0)
                                      ? (product.preco >= _priceRange.start &&
                                          product.preco <= _priceRange.end)
                                      : true;
                              final isMatchingEstado = _estado != 'Selecione'
                                  ? product.estado == _estado
                                  : true;
                              final isMatchingAno = _ano != 2000
                                  ? product.ano == _ano.toString()
                                  : true;
                              final isMatchingKm = _km != 0
                                  ? int.parse(product.km) <= _km
                                  : true;
                              final isMatchingOpcao = _opcao == 'Selecione'
                                  ? true
                                  : _opcao == 'Venda'
                                      ? product.isForRent == false
                                      : product.isForRent == true;

                              final isMatchingCor =
                                  _cor != '' ? product.cor == _cor : true;
                              return isMatchingSearchValue &&
                                  isWithinPriceRange &&
                                  isMatchingEstado &&
                                  isMatchingAno &&
                                  isMatchingKm &&
                                  isMatchingCor &&
                                  isMatchingOpcao;
                            }).toList()
                          : [];

                      return GridView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: filteredProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (ctx, i) =>
                            ChangeNotifierProvider<Car>.value(
                          value: filteredProducts[i],
                          child: const ProductItem(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedItem: NavigationItem(Icons.search),
      ),
    );
  }
}
