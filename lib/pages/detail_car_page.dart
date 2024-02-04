import 'package:auto_car/components/bottom_navigation_bar.dart';
import 'package:auto_car/models/car.dart';
import 'package:auto_car/models/car_list.dart';
import 'package:auto_car/models/carrinho.dart';
import 'package:auto_car/models/order_list.dart';
import 'package:auto_car/models/place.dart';
import 'package:auto_car/components/view_map.dart';
import 'package:auto_car/pages/reservar/reservar_page.dart';
import 'package:auto_car/utils/location_util.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_view_indicator/flutter_page_view_indicator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DetailCarPage extends StatefulWidget {
  DetailCarPage({required this.userId, required this.product, super.key});
  final Car product;
  String userId;

  @override
  State<DetailCarPage> createState() => _DetailCarPageState();
}

class _DetailCarPageState extends State<DetailCarPage> {
  List<Reference> refs = [];
  List<String> arquivos = [];

  final FirebaseStorage storage = FirebaseStorage.instance;
  bool loading = true;
  PageController? _pageController;
  late int _currentIndex = 0;
  String previewImageUrl = '';
  late String address = '';
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    loadUserIdsAndImages();
  }

  Future<void> loadUserIdsAndImages() async {
    final userId = Provider.of<CarList>(context, listen: false);
    List<String> listUser = await userId.loadUserIds();
    //await loadImages(widget.userId, widget.product.apelido);
    await loadImg(listUser, widget.product.apelido);
    if (widget.product.isForRent) {
      address =
          await LocationUtil.getAddressFrom(widget.product.location as LatLng);
      setState(() {});
    }
  }

  loadImages(String userId, String nomeCar) async {
    refs = (await storage.ref('$userId/$nomeCar').listAll()).items;
    for (var ref in refs) {
      final arquivo = await ref.getDownloadURL();
      arquivos.add(arquivo);
    }
    setState(() => loading = false);
  }

  Future<void> loadImg(List<String> userIds, String nomeCar) async {
    int i = 0;
    for (String userId in userIds) {
      refs = (await storage.ref('$userId/vender/$nomeCar/').listAll()).items;
      for (var ref in refs) {
        if (refs.length > i) {
          final arquivo = await ref.getDownloadURL();
          arquivos.add(arquivo);
          i++;
        } else {
          break;
        }
      }
    }
    i = 0;
    for (String userId in userIds) {
      refs = (await storage.ref('$userId/alugar/$nomeCar/').listAll()).items;
      for (var ref in refs) {
        if (refs.length > i) {
          final arquivo = await ref.getDownloadURL();
          arquivos.add(arquivo);
          i++;
        } else {
          break;
        }
      }
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final carrinho = Provider.of<Carrinho>(context);
    final precoFormatado = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
        .format(widget.product.preco);
    if (widget.product.isForRent) {
      previewImageUrl = LocationUtil.generateLocationPreviewImage(
        latitude: widget.product.location!.latitude,
        longitude: widget.product.location!.longitude,
      );
    }

    // print(cart.id);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            widget.product.modelo,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          //margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: arquivos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        arquivos[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                  onPageChanged: (int index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 10,
                width: 100,
                child: Transform.translate(
                  offset: const Offset(0, 600),
                  child: PageViewIndicator(
                    length: arquivos.length,
                    currentIndex: _currentIndex,
                  ),
                ),
              ),
              if (arquivos.length > 1)
                PageViewIndicator(
                  length: arquivos.length,
                  currentIndex: _currentIndex,
                  currentColor: const Color.fromARGB(
                      255, 0, 0, 0), //Theme.of(context).colorScheme.primary,
                  otherColor: const Color.fromARGB(255, 158, 155, 155),
                  currentSize: 10,
                  otherSize: 10,
                  margin: const EdgeInsets.all(5),
                  borderRadius: 9999.0,
                  alignment: MainAxisAlignment.center,
                  animationDuration: const Duration(milliseconds: 750),
                ),

//************************************************************** */

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.only(left: 325, top: 20)),
                  widget.product.isForRent == false
                      ? const Text(
                          'Valor ',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lato',
                            color: Color.fromARGB(255, 32, 46, 85),
                          ),
                        )
                      : const Text(
                          'Preço por dia/24h',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lato',
                            color: Color.fromARGB(255, 32, 46, 85),
                          ),
                        ),
                  Text(
                    precoFormatado,
                    style: TextStyle(
                      fontSize: 27,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ), // Ano do carro
                ],
              ),
              const Padding(padding: EdgeInsets.all(15)),
              SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    if (widget.product.isForRent == false) {
                      final Carrinho cart = Provider.of(context, listen: false);
                      cart.addItem(widget.product);
                      await Provider.of<OrderList>(
                        context,
                        listen: false,
                      ).addOrder(cart);

                      cart.clear();
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) =>
                              ReservaPage(product: widget.product),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    // Cor de fundo
                  ),
                  // ignore: unnecessary_null_comparison
                  child: (widget.product.isForRent == false)
                      ? Text(
                          'Comprar',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 19,
                            fontFamily: 'Lato',
                          ),
                        )
                      : Text(
                          'Reservar',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 19,
                            fontFamily: 'Lato',
                          ),
                        ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(2)),
              if (widget.product.isForRent == false)
                SizedBox(
                  width: 300,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      // setState(() {
                      //   selectedItem = NavigationItem(Icons.home);
                      // });

                      carrinho.addItem(widget.product);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      'Adicionar ao carrinho',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 19,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              const Padding(padding: EdgeInsets.all(12)),

              //************************************************** */
              if (widget.product.isForRent)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(color: Colors.black),
                    const Padding(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        'Localização do Veiculo:',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Lato',
                          color: Color.fromARGB(255, 32, 46, 85),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => ViewMapPage(
                              initialLocation: PlaceLocation(
                                latitude: widget.product.location!.latitude,
                                longitude: widget.product.location!.longitude,
                              ),
                              isReadonly: false,
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          SizedBox(
                            height: 170,
                            width: double.infinity,
                            child: Image.network(
                              previewImageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            color: Colors.black.withOpacity(0.7),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Text(
                              address,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              const Padding(padding: EdgeInsets.all(10)),
              const Divider(color: Colors.black),
              const Padding(padding: EdgeInsets.all(10)),
              SizedBox(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Descrição: ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                        color: Color.fromARGB(255, 32, 46, 85),
                      ),
                    ),
                    Text(
                      widget.product.descricao,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    const Divider(color: Colors.black),
                    const Padding(padding: EdgeInsets.all(10)),
                    const Text(
                      'Caracteristicas do produto',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                        color: Color.fromARGB(255, 32, 46, 85),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 20),
                      child: Row(
                        children: [
                          const Text(
                            'Estado: ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Color.fromARGB(255, 32, 46, 85),
                            ),
                          ),
                          Text(
                            widget.product.estado,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 20),
                      child: Row(
                        children: [
                          const Text(
                            'Marca: ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Color.fromARGB(255, 32, 46, 85),
                            ),
                          ), // Rótulo 'Marca'
                          Text(
                            widget.product.marca,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 20),
                      child: Row(
                        children: [
                          const Text('Ano: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Color.fromARGB(255, 32, 46, 85),
                              )),
                          Text(
                            widget.product.ano,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 20),
                      child: Row(
                        children: [
                          const Text(
                            'km: ',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.normal,
                              color: Color.fromARGB(255, 32, 46, 85),
                            ),
                          ),
                          Text(
                            widget.product.km,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 20),
                      child: Row(
                        children: [
                          const Text(
                            'Cor: ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Color.fromARGB(255, 32, 46, 85),
                            ),
                          ),
                          Text(
                            widget.product.cor,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // const Padding(padding: EdgeInsets.all(10)),
                    // const Divider(color: Colors.black),
                    // const Padding(padding: EdgeInsets.all(10)),
                    // const Text(
                    //   'Informações sobre o vendedor',
                    //   style: TextStyle(
                    //     fontSize: 22,
                    //     fontWeight: FontWeight.normal,
                    //     color: Color.fromARGB(255, 32, 46, 85),
                    //   ),
                    // ),
                    // const Text(
                    //   'Nome: José Batista',
                    //   style: TextStyle(
                    //     fontSize: 15,
                    //     fontWeight: FontWeight.bold,
                    //     color: Color.fromARGB(255, 32, 46, 85),
                    //   ),
                    // ),
                    // const Text(
                    //   'Contato: (99) 99999 - 9999',
                    //   style: TextStyle(
                    //     fontSize: 15,
                    //     fontWeight: FontWeight.bold,
                    //     color: Color.fromARGB(255, 32, 46, 85),
                    //   ),
                    // ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.all(15)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedItem: NavigationItem(Icons.exposure_zero),
      ),
    );
  }
}
