// import 'package:auto_car/models/auth.dart';
// import 'package:auto_car/models/car.dart';
// import 'package:auto_car/models/car_list.dart';
// import 'package:auto_car/pages/detail_car_page.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// // ignore: depend_on_referenced_packages
// import 'package:provider/provider.dart';

// class ProductItem extends StatefulWidget {
//   const ProductItem({super.key});

//   @override
//   State<ProductItem> createState() => _ProductItemState();
// }

// class _ProductItemState extends State<ProductItem> {
//   List<Reference> refs = [];
//   List<String> arquivos = [];

//   final FirebaseStorage storage = FirebaseStorage.instance;
//   bool loading = true;
//   @override
//   void initState() {
//     super.initState();
//     loadUserIdsAndImages();
//   }

//   Future<void> loadUserIdsAndImages() async {
//     final product = Provider.of<Car>(context, listen: false);
//     final userId = Provider.of<CarList>(context, listen: false);
//     List<String> listUser = await userId.loadUserIds();
//     await loadImages(listUser, product.apelido);
//   }

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   final product = Provider.of<Car>(context, listen: false);
//   //   final userId = Provider.of<CarList>(context, listen: false);
//   //   List<String> listUser = userId.loadUserIds as List<String>;
//   //   loadImages(listUser, product.apelido);
//   // }

//   // loadImages(String userId, String nomeCar) async {
//   //   refs = (await storage.ref('$userId/$nomeCar').listAll()).items;
//   //   for (var ref in refs) {
//   //     final arquivo = await ref.getDownloadURL();
//   //     arquivos.add(arquivo);

//   //     // print('aaaaaaaaaaaaaaaaaaaaaaa');
//   //     // print(arquivos);
//   //   }
//   //   setState(() => loading = false);
//   // }
//   Future<void> loadImages(List<String> userIds, String nomeCar) async {
//     for (String userId in userIds) {
//       refs = (await storage.ref('$userId/$nomeCar').listAll()).items;
//       for (var ref in refs) {
//         final arquivo = await ref.getDownloadURL();
//         arquivos.add(arquivo);
//       }
//     }
//     setState(() => loading = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<Auth>(context, listen: false);
//     final product = Provider.of<Car>(context, listen: false);
//     if (loading) {
//       return const Center(child: CircularProgressIndicator());
//     } else {
//       return Card(
//         color: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius:
//               BorderRadius.circular(15), // Adiciona bordas arredondadas
//         ),
//         elevation: 5, // Adiciona sombra ao cartão
//         margin: const EdgeInsets.all(10),
//         child: GestureDetector(
//           onTap: () {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (ctx) => DetailCarPage(product: product),
//               ),
//             );
//           },
//           child: Column(
//             children: <Widget>[
//               Stack(
//                 children: <Widget>[
//                   ClipRRect(
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(15),
//                         topRight: Radius.circular(15),
//                       ),
//                       child: arquivos.isNotEmpty
//                           ? Image(
//                               image: CachedNetworkImageProvider(arquivos.first),
//                               height: 150,
//                               width: double.infinity,
//                               fit: BoxFit.cover,
//                             )
//                           : Container()

//                       // Image.network(
//                       //   product.imageUrl,
//                       //   height: 150,
//                       //   width: double.infinity,
//                       //   fit: BoxFit.cover,
//                       // ),
//                       ),
//                   Positioned(
//                     top: 8.0,
//                     right: 8.0,
//                     child: IconButton(
//                       onPressed: () {
//                         setState(() {
//                           product.toggleFavorite(
//                             auth.token ?? '',
//                             auth.userId ?? '',
//                           );
//                         });
//                       },
//                       icon: Icon(
//                         product.isFavorite
//                             ? Icons.favorite
//                             : Icons.favorite_border,
//                         size: 30,
//                         color: Theme.of(context).colorScheme.primary,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 width: 400,
//                 height: 100,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Column(
//                     crossAxisAlignment:
//                         CrossAxisAlignment.start, // Alinha os textos à esquerda
//                     children: [
//                       Text(
//                         product.marca,
//                         style: const TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Color.fromARGB(255, 32, 46,
//                                 85) //Colors.blue.shade900, // Altera a cor do texto
//                             ),
//                       ),
//                       Text(
//                         product.ano,
//                         style: const TextStyle(
//                           fontSize: 17,
//                           color: Color.fromARGB(
//                               255, 123, 123, 123), // Altera a cor do texto
//                         ),
//                       ),
//                       Text(
//                         product.modelo,
//                         style: const TextStyle(
//                           fontSize: 17,
//                           color: Color.fromARGB(
//                               255, 123, 123, 123), // Altera a cor do texto
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.center,
//                 child: TextButton(
//                   child: const Text(
//                     'Ver Mais',
//                     style: TextStyle(
//                         fontSize: 17, color: Color.fromARGB(255, 0, 0, 255)),
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (ctx) => DetailCarPage(product: product),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//   }
// }

import 'package:auto_car/models/auth.dart';
import 'package:auto_car/models/car.dart';
import 'package:auto_car/models/car_list.dart';
import 'package:auto_car/pages/detail_car_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({super.key});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  List<Reference> refs = [];
  List<String> arquivos = [];
  late String user = '';
  final FirebaseStorage storage = FirebaseStorage.instance;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    loadUserIdsAndImages();
  }

  Future<void> loadUserIdsAndImages() async {
    final product = Provider.of<Car>(context, listen: false);
    final userId = Provider.of<CarList>(context, listen: false);
    List<String> listUser = await userId.loadUserIds();
    await loadImages(listUser, product.apelido);
  }

  Future<void> loadImages(List<String> userIds, String nomeCar) async {
    for (String userId in userIds) {
      refs = (await storage.ref('$userId/vender/$nomeCar').listAll()).items;
      user = userId;
      for (var ref in refs) {
        final arquivo = await ref.getDownloadURL();
        arquivos.add(arquivo);
      }
    }
    for (String userId in userIds) {
      refs = (await storage.ref('$userId/alugar/$nomeCar').listAll()).items;
      user = userId;
      for (var ref in refs) {
        final arquivo = await ref.getDownloadURL();
        arquivos.add(arquivo);
      }
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final product = Provider.of<Car>(context, listen: false);
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(15), // Adiciona bordas arredondadas
        ),
        elevation: 20, // Adiciona sombra ao cartão

        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => DetailCarPage(
                  product: product,
                  userId: user,
                ),
              ),
            );
          },
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      child: arquivos.isNotEmpty
                          ? Image(
                              image: CachedNetworkImageProvider(arquivos.first),
                              height: 95,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Container()

                      // Image.network(
                      //   product.imageUrl,
                      //   height: 150,
                      //   width: double.infinity,
                      //   fit: BoxFit.cover,
                      // ),
                      ),
                  Positioned(
                    top: -7,
                    right: -3,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          product.toggleFavorite(
                            auth.token ?? '',
                            auth.userId ?? '',
                          );
                        });
                      },
                      icon: Icon(
                        product.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 30,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, left: 15),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          product.isForRent == true
                              ? Text(
                                  product.marca,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 32, 46,
                                          85) //Colors.blue.shade900, // Altera a cor do texto
                                      ),
                                )
                              : Text(
                                  product.marca,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 32, 46,
                                          85) //Colors.blue.shade900, // Altera a cor do texto
                                      ),
                                ),
                          Text(
                            product.ano,
                            style: const TextStyle(
                              fontSize: 17,
                              color: Color.fromARGB(
                                  255, 123, 123, 123), // Altera a cor do texto
                            ),
                          ),
                          Text(
                            product.modelo,
                            style: const TextStyle(
                              fontSize: 17,
                              color: Color.fromARGB(
                                  255, 123, 123, 123), // Altera a cor do texto
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    child: product.isForRent == true
                        ? const Column(
                            children: [
                              Divider(
                                thickness: 1,
                                color: Colors.black87,
                              ),
                              Text(
                                'Alugue agora!',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 0, 0, 255)),
                              )
                            ],
                          )
                        : const Text(
                            'Ver Mais',
                            style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 0, 0, 255)),
                          ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => DetailCarPage(
                            product: product,
                            userId: user,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
