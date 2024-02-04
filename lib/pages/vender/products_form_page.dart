// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously
import 'dart:io';
import 'package:auto_car/components/app_drawer.dart';
import 'package:auto_car/components/bottom_navigation_bar.dart';
import 'package:auto_car/models/auth.dart';
import 'package:auto_car/models/car.dart';
import 'package:auto_car/models/car_list.dart';
import 'package:auto_car/models/routeArguments.dart';
import 'package:auto_car/pages/produtos_car_screen.dart';
import 'package:auto_car/utils/app_routes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  // ignore: unused_field
  late File _pickedImage;
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  //final _imageUrlController = TextEditingController();
  bool _isLoading = false;
  final _imageUrlFocus = FocusNode();
  File? _storedImage;
  late String? _groupValue = _formData['estado'] as String?;
  final FirebaseStorage storage = FirebaseStorage.instance;
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<Reference> refs = [];
  List<String> arquivos = [];
  bool loading = true;
  bool uploading = false;
  double total = 0;
  late String nomeCar = '';

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
    nomeCar =
        _formData['apelido'] != null ? _formData['apelido'].toString() : '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final args =
          ModalRoute.of(context)?.settings.arguments as RouteArguments?;
      if (args != null) {
        final product = args.product;
        _formData['id'] = product.id;
        _formData['apelido'] = product.apelido;
        _formData['marca'] = product.marca;
        _formData['modelo'] = product.modelo;
        _formData['ano'] = product.ano;
        _formData['km'] = product.km;
        _formData['cor'] = product.cor;
        _formData['preco'] = product.preco;
        _formData['descricao'] = product.descricao;
        _formData['estado'] = product.estado;
      }
    }
  }

  void _selectImage(File pickedImage) {
    setState(() {
      _pickedImage = pickedImage;
      _formData['image'] = pickedImage;
    });
  }

  // ignore: unused_element
  _takePicture() async {
    // ignore: no_leading_underscores_for_local_identifiers
    final ImagePicker _picker = ImagePicker();
    XFile imageFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    ) as XFile;

    setState(() {
      _storedImage = File(imageFile.path);
    });

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    String fileName = path.basename(_storedImage!.path);
    final savedImage = await _storedImage!.copy('${appDir.path}/$fileName');

    _selectImage(savedImage);
  }

  void updateImage() {
    setState(() {});
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    setState(() => _isLoading = true);

    try {
      await Provider.of<CarList>(
        context,
        listen: false,
      ).saveProduct(_formData);

      //Navigator.of(context).pop();

      Navigator.pushNamed(context, AppRoutes.PRODUCTS);
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Ocorreu um erro!"),
          content: Text("Ocorreu um erro para salvar o produto. Erro: $error"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Ok"),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void openFiles(List<PlatformFile> files) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ProductCarPage(),
      ),
    );
  }

  Future<File> saveFile(PlatformFile file) async {
    final appStorage = await syspaths.getApplicationCacheDirectory();
    final newFile = File(appStorage.path);
    return File(file.path!).copy(newFile.path);
  }

  Future<XFile?> getImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<List<UploadTask>> upload(
      List<String> paths, String userId, String nomeCar) async {
    List<UploadTask> tasks = [];
    for (String path in paths) {
      File file = File(path);
      try {
        String ref =
            '$userId/vender/$nomeCar/img-${DateTime.now().toString()}.jpeg';
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
    List<XFile>? files = await ImagePicker().pickMultiImage();
    List<String> paths = files.map((file) => file.path).toList();
    List<UploadTask> tasks = await upload(paths, userId, nomeCar);

    for (UploadTask task in tasks) {
      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        if (snapshot.state == TaskState.running) {
          setState(() {
            total = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          });
        } else if (snapshot.state == TaskState.success) {
          final photoRef = snapshot.ref;

          arquivos.add(await photoRef.getDownloadURL());
          refs.add(photoRef);
          setState(() {});
        }
      });
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Mensagem'),
          content: const Text('Imagens adicionadas com sucesso!'),
          actions: <Widget>[
            ElevatedButton(
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

  bool isNotEmpty(String input) {
    return input.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
//    final args = ModalRoute.of(context)!.settings.arguments;
    final args = ModalRoute.of(context)?.settings.arguments as RouteArguments?;

    late bool isEditing = false;
    if (args != null) {
      isEditing = args.isEditing;
    } else {
      isEditing = false;
    }

    final user = Provider.of<Auth>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar Carro"),
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      drawer: const AppDrawer(),
      bottomNavigationBar:
          CustomBottomNavigationBar(selectedItem: NavigationItem(Icons.abc)),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ignore: duplicate_ignore
                      if (!isEditing)
                        TextFormField(
                          initialValue: isEditing
                              ? nomeCar = _formData['apelido']!.toString()
                              : nomeCar,
                          //_formData['apelido']?.toString(),
                          decoration: const InputDecoration(
                            labelText: 'Titulo',
                          ),
                          textInputAction: TextInputAction.next,
                          onChanged: (apelido) {
                            setState(() {
                              nomeCar = apelido;
                            });
                          },
                          onSaved: (apelido) =>
                              _formData['apelido'] = apelido ?? '',
                          validator: (Apelido) {
                            final apelido = Apelido ?? '';
                            if (apelido.trim().isEmpty) {
                              return 'Titulo do carro é obrigatorio!';
                            }
                            return null;
                          },
                        ),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: _formData['marca']?.toString(),
                              decoration: const InputDecoration(
                                labelText: 'Marca',
                              ),
                              textInputAction: TextInputAction.next,
                              onSaved: (marca) =>
                                  _formData['marca'] = marca ?? '',
                              validator: (Marca) {
                                final marca = Marca ?? '';
                                if (marca.trim().isEmpty) {
                                  return 'Marca é obrigatorio!';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: TextFormField(
                              initialValue: _formData['modelo']?.toString(),
                              decoration: const InputDecoration(
                                labelText: 'Modelo',
                              ),
                              textInputAction: TextInputAction.next,
                              onSaved: (modelo) =>
                                  _formData['modelo'] = modelo ?? '',
                              validator: (Modelo) {
                                final modelo = Modelo ?? '';
                                if (modelo.trim().isEmpty) {
                                  return 'Modelo é obrigatorio!';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16.0),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: _formData['ano']?.toString(),
                              decoration: const InputDecoration(
                                labelText: 'Ano',
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              onSaved: (ano) => _formData['ano'] = ano ?? '',
                              validator: (Ano) {
                                final ano = Ano ?? '';
                                if (ano.trim().isEmpty) {
                                  return 'Ano é obrigatorio!';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: TextFormField(
                              initialValue: _formData['km']?.toString(),
                              decoration: const InputDecoration(
                                labelText: 'Km',
                              ),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              onSaved: (km) => _formData['km'] = km ?? '',
                              validator: (Km) {
                                final km = Km ?? '';
                                if (km.trim().isEmpty) {
                                  return 'Marca é obrigatorio!';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: TextFormField(
                              initialValue: _formData['cor']?.toString(),
                              decoration: const InputDecoration(
                                labelText: 'Cor',
                              ),
                              textInputAction: TextInputAction.next,
                              onSaved: (cor) => _formData['cor'] = cor ?? '',
                              validator: (Cor) {
                                final cor = Cor ?? '';
                                if (cor.trim().isEmpty) {
                                  return 'Cor é obrigatorio!';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16.0),

                      TextFormField(
                        initialValue: _formData['preco']?.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Preço',
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onSaved: (valor) =>
                            _formData['preco'] = double.parse(valor ?? '0'),
                        validator: (Preco) {
                          final priceString = Preco ?? '';
                          final price = double.tryParse(priceString) ?? -1;

                          if (price <= 0) {
                            return 'Informe um Preço válido!';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: _formData['descricao']?.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Descrição',
                        ),
                        maxLines: 3,
                        onSaved: (descricao) =>
                            _formData['descricao'] = descricao ?? '',
                        validator: (Descricao) {
                          final descricao = Descricao ?? '';
                          if (descricao.trim().isEmpty) {
                            return 'Descrição é obrigatorio!';
                          }
                          if (descricao.trim().length < 10) {
                            return 'Descrição precisa no minimo de 10 letras';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      const Text('Veículo'),
                      Row(
                        children: [
                          Radio(
                            value: 'Novo',
                            groupValue: _groupValue,
                            activeColor: Colors.black,
                            onChanged: (value) {
                              setState(() {
                                _groupValue = value!;
                                _formData['estado'] = _groupValue!;
                              });
                            },
                          ),
                          const Text('Novo'),
                          Radio(
                            value: 'Usado',
                            groupValue: _groupValue,
                            activeColor: Colors.black,
                            onChanged: (value) {
                              setState(() {
                                _groupValue = value!;

                                _formData['estado'] = _groupValue!;
                              });
                            },
                          ),
                          const Text('Usado'),
                        ],
                      ),
                      const SizedBox(height: 16.0),

                      ElevatedButton(
                        onPressed: () {
                          // //String id = product.id;
                          if (isEditing) {
                            final product =
                                Provider.of<Car>(context, listen: false);
                            final prod =
                                Provider.of<CarList>(context, listen: false);
                            prod.loadProducts();
                            final bool text = product.isForRent;
                            nomeCar = _formData['apelido']!.toString();
                            Navigator.of(context).pushNamed(
                                AppRoutes.EDITSTORAGE,
                                arguments: {'nomeCar': nomeCar, 'text': text});
                          } else {
                            if (nomeCar.isNotEmpty) {
                              pickAndUploadImage(
                                  user.userId as String, nomeCar);
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Mensagem!'),
                                    content:
                                        const Text('Prencha os campos acima!'),
                                    actions: [
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          // Coloque aqui o código que deve ser executado quando o botão OK for pressionado.
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        },
                        child: isEditing
                            ? const Text('Editar Imagens')
                            : const Text('Adicionar Imagens'),
                      ),
                      if (!isEditing)
                        SizedBox(
                          child:
                              Text('Quantidade de imagens: ${arquivos.length}'),
                        ),
                      const SizedBox(height: 22),
                      const Padding(padding: EdgeInsets.all(2)),
                      Center(
                        child: SizedBox(
                          width: 300,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              if (arquivos.isEmpty) {
                                AlertDialog(
                                  title: const Text("Ocorreu um erro!"),
                                  content:
                                      const Text("Imagens não adicionadas!"),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text("Ok"),
                                    ),
                                  ],
                                );
                              } else {
                                _submitForm();
                              }
                              //_submitForm();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 4,
                            ),
                            child: Text(
                              'Concluir',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
