import 'dart:io';
import 'package:auto_car/models/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class EditStoragePage extends StatefulWidget {
  const EditStoragePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditStoragePageState createState() => _EditStoragePageState();
}

class _EditStoragePageState extends State<EditStoragePage> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<Reference> refs = [];
  List<String> arquivos = [];
  bool loading = true;
  bool uploading = false;
  double total = 0;

  Future<XFile?> getImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<List<UploadTask>> upload(
      List<String> paths, String userId, String nomeCar) async {
    List<UploadTask> tasks = [];
    late String tipo = '';
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final text = arguments['text'] as bool;
    if (text) {
      tipo = 'alugar';
    } else {
      tipo = 'vender';
    }
    for (String path in paths) {
      File file = File(path);
      try {
        String ref =
            '$userId/$tipo/$nomeCar/img-${DateTime.now().toString()}.jpeg';
        final storageRef = FirebaseStorage.instance.ref();
        tasks.add(storageRef.child(ref).putFile(
              file,
              SettableMetadata(
                cacheControl: "public, max-age=300",
                contentType: "image/jpeg",
              ),
            ));
      } on FirebaseException catch (e) {
        throw Exception('Erro no upload: ${e.code}');
      }
    }
    return tasks;
  }

  pickAndUploadImage(String userId, String nomeCar) async {
    final ImagePicker picker = ImagePicker();

    List<XFile>? files = await picker.pickMultiImage();
    List<UploadTask> tasks =
        await upload(files.map((file) => file.path).toList(), userId, nomeCar);

    for (UploadTask task in tasks) {
      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        if (snapshot.state == TaskState.running) {
          setState(() {
            uploading = true;
            total = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          });
        } else if (snapshot.state == TaskState.success) {
          final photoRef = snapshot.ref;

          arquivos.add(await photoRef.getDownloadURL());
          refs.add(photoRef);

          setState(() => uploading = false);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final user = Provider.of<Auth>(context, listen: false);
      final userId = user.userId;
      //final nomeCar = ModalRoute.of(context)!.settings.arguments as String;
      final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
      final nomeCar = arguments['nomeCar'] as String;

      loadImages(userId!, nomeCar);
    });
  }

  loadImages(String userId, String nomeCar) async {
    late String tipo = '';
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final text = arguments['text'] as bool;
    if (text) {
      tipo = 'alugar';
    } else {
      tipo = 'vender';
    }
    // final SharedPreferences prefs = await _prefs;
    // arquivos = prefs.getStringList('images') ?? [];

    // if (arquivos.isEmpty) {
    refs = (await storage.ref('$userId/$tipo/$nomeCar').listAll()).items;
    for (var ref in refs) {
      final arquivo = await ref.getDownloadURL();
      arquivos.add(arquivo);
    }
    // prefs.setStringList('images', arquivos);
    // }
    setState(() => loading = false);
  }

  // deleteImage(int index) async {
  //   await storage.ref(refs[index].fullPath).delete();
  //   arquivos.removeAt(index);
  //   refs.removeAt(index);
  //   setState(() {});
  // }
  deleteImage(int index) async {
    // Verifique se há mais de uma imagem antes de excluir
    if (arquivos.length > 1) {
      await storage.ref(refs[index].fullPath).delete();
      arquivos.removeAt(index);
      refs.removeAt(index);
      setState(() {});
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text(
                'Não é possível excluir todas as imagens, uma deve permanecer.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context, listen: false);
    //final nomeCar = ModalRoute.of(context)!.settings.arguments as String;
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final nomeCar = arguments['nomeCar'] as String;
    final text = arguments['text'] as bool;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            text ? Colors.green : Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: uploading
            ? Text('${total.round()}% enviado')
            : const Text('Suas Imagens'),
        actions: [
          uploading
              ? const Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Center(
                    child: SizedBox(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.upload),
                  onPressed: () {
                    pickAndUploadImage(user.userId as String, nomeCar
                        // product.productId as String,
                        );
                  }),
        ],
        elevation: 0,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(30.0),
              child: arquivos.isEmpty
                  ? const Center(child: Text('Não há imagens ainda.'))
                  : ListView.builder(
                      itemBuilder: (BuildContext context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: ListTile(
                            leading: SizedBox(
                              width: 140,
                              height: 100,
                              child: Image(
                                image:
                                    CachedNetworkImageProvider(arquivos[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text('Image ${(index + 1)}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => deleteImage(index),
                            ),
                          ),
                        );
                      },
                      itemCount: arquivos.length,
                    ),
            ),
    );
  }
}
