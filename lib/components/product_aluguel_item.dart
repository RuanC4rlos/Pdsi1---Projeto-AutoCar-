// ignore_for_file: depend_on_referenced_packages, unrelated_type_equality_checks

import 'package:auto_car/exceptions/http_exception.dart';
import 'package:auto_car/models/auth.dart';
import 'package:auto_car/models/car.dart';
import 'package:auto_car/models/car_list.dart';
import 'package:auto_car/models/routeArguments.dart';
import 'package:auto_car/utils/app_routes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductAlugarItem extends StatefulWidget {
  final Car product;
  const ProductAlugarItem({required this.product, super.key});

  @override
  State<ProductAlugarItem> createState() => _ProductAlugarItemState();
}

class _ProductAlugarItemState extends State<ProductAlugarItem> {
  final FirebaseStorage storage = FirebaseStorage.instance;

  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<Reference> refs = [];

  List<String> arquivos = [];

  bool loading = true;
  @override
  void initState() {
    super.initState();
    final user = Provider.of<Auth>(context, listen: false);

    loadImages(user.userId as String, widget.product.apelido);
  }

  loadImages(String userId, String nomeCar) async {
    refs = (await storage.ref('$userId/alugar/$nomeCar').listAll()).items;
    if (refs.isNotEmpty) {
      final arquivo = await refs.first.getDownloadURL();
      arquivos.add(arquivo);
      setState(() => loading = false);
    }

    for (var ref in refs.skip(1)) {
      final arquivo = await ref.getDownloadURL();
      arquivos.add(arquivo);
    }
  }

  deleteFolder(String userId, String nomeCar) async {
    late int index = 0;
    refs = (await storage.ref('$userId/alugar/$nomeCar').listAll()).items;
    for (var ref in refs) {
      final arquivo = await ref.getDownloadURL();
      arquivos.add(arquivo);
    }
    while (index < arquivos.length) {
      await storage.ref(refs[index].fullPath).delete();
      arquivos.removeAt(index);
      refs.removeAt(index);
      setState(() {});
      index += 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final msg = ScaffoldMessenger.of(context);
    final user = Provider.of<Auth>(context, listen: false);

    if (loading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return ListTile(
        leading: SizedBox(
          width: 60,
          height: 60,
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(arquivos.first),

            //backgroundImage: NetworkImage(widget.product.imageUrl),
          ),
        ),
        title: Text(
          widget.product.apelido,
          style: const TextStyle(fontSize: 17),
        ),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.PRODUCTFORMALUGUEL,
                    arguments: RouteArguments(
                        isEditing: true, product: widget.product),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).colorScheme.error,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Excluir Produto'),
                      content: const Text('Tem certeza?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text('Não'),
                        ),
                        TextButton(
                          onPressed: () {
                            Provider.of<CarList>(
                              context,
                              listen: false,
                            ).removeProductAlugado(widget.product);
                            //Navigator.of(ctx).pop();
                            deleteFolder(
                                user.userId as String, widget.product.apelido);
                            Navigator.of(context)
                                .pushNamed(AppRoutes.RESERVAR_CAR);
                          },
                          child: const Text('Sim'),
                        ),
                      ],
                    ),
                  ).then(
                    (value) async {
                      if (value ?? false) {
                        try {
                          await Provider.of<CarList>(
                            context,
                            listen: false,
                          ).removeProduct(widget.product);
                        } on HttpException catch (error) {
                          msg.showSnackBar(
                            SnackBar(
                              content: Text(
                                error.toString(),
                              ),
                            ),
                          );
                        }
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      );
    }
  }
}
