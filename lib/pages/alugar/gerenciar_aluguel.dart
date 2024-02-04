import 'package:auto_car/components/app_drawer.dart';
import 'package:auto_car/components/bottom_navigation_bar.dart';
import 'package:auto_car/components/product_aluguel_item.dart';
import 'package:auto_car/models/auth.dart';
import 'package:auto_car/models/car.dart';
import 'package:auto_car/models/car_list.dart';
import 'package:auto_car/utils/app_routes.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlugarPage extends StatefulWidget {
  const AlugarPage({super.key});

  @override
  State<AlugarPage> createState() => _AlugarPageState();
}

class _AlugarPageState extends State<AlugarPage> {
  late bool _isLoading = true;

  final FirebaseStorage storage = FirebaseStorage.instance;
  List<Reference> refs = [];

  List<String> arquivos = [];
  @override
  void initState() {
    super.initState();
    _loadData();
    _refreshUserProducts(context);
  }

  Future<void> _refreshUserProducts(BuildContext context) {
    return Provider.of<CarList>(
      context,
      listen: false,
    ).loadUserProductsAlugados().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> loadImages(List<String> userIds, String nomeCar) async {
    for (String userId in userIds) {
      refs = (await storage.ref('$userId/alugar/$nomeCar').listAll()).items;
      for (var ref in refs) {
        final arquivo = await ref.getDownloadURL();
        arquivos.add(arquivo);
      }
    }
    setState(() {});
  }

  Future<void> _loadData() async {
    await Provider.of<CarList>(
      context,
      listen: false,
    ).loadProductsAlugados();

    // ignore: use_build_context_synchronously
    String userId = Provider.of<Auth>(context, listen: false) as String;

    // ignore: use_build_context_synchronously
    String nomeCar = Provider.of<Car>(context, listen: false) as String;
    arquivos = loadImages(userId as List<String>, nomeCar) as List<String>;
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<CarList>(context, listen: false);

    return Scaffold(
      appBar: products.userItems.isEmpty
          ? null
          : AppBar(
              title: const Text('Veiculos para Alugar'),
              backgroundColor: Colors.green,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.PRODUCTFORMALUGUEL);
                  },
                  icon: const Icon(Icons.add),
                )
              ],
            ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.userItems.isEmpty
              ? Container(
                  color: Colors.white,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Column(
                        children: [
                          Text(
                            'Alugue',
                            style: TextStyle(
                              fontSize: 46,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Lato',
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            'seu',
                            style: TextStyle(
                              fontSize: 46,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Lato',
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            'Veículo agora!',
                            style: TextStyle(
                              fontSize: 46,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Lato',
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 20)),
                          Image.asset(
                            'assets/images/anuncio_alugar.png',
                            height: 274,
                            //color: const Color(0xFF003BDF),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 50)),
                          SizedBox(
                            height: 50,
                            width: 300,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(AppRoutes.PRODUCTFORMALUGUEL);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 4,
                                // Cor de fundo
                              ),
                              child: Text(
                                'Continuar',
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 25,
                                    fontFamily: 'Lato',
                                    fontWeight: FontWeight.w600,
                                    height: 0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => _refreshUserProducts(context),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListView.builder(
                      itemCount: products.userItems.length,
                      itemBuilder: (ctx, i) =>
                          ProductAlugarItem(product: products.userItems[i]),
                    ),
                  ),
                ),
      bottomNavigationBar:
          CustomBottomNavigationBar(selectedItem: NavigationItem(Icons.abc)),
    );
  }
}
