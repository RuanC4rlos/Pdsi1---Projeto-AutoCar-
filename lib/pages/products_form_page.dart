// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:io';
import 'package:auto_car/components/app_drawer.dart';
import 'package:auto_car/components/bottom_navigation_bar.dart';
import 'package:auto_car/models/car.dart';
import 'package:auto_car/models/car_list.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart' as syspaths;
// ignore: duplicate_import
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:image_picker/image_picker.dart';
// ignore: depend_on_referenced_packages
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
  final _imageUrlController = TextEditingController();
  bool _isLoading = false;
  final _imageUrlFocus = FocusNode();
  File? _storedImage;

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final product = arg as Car;
        _formData['id'] = product.id;
        _formData['cpf'] = product.cpf;
        _formData['marca'] = product.marca;
        _formData['modelo'] = product.modelo;
        _formData['ano'] = product.ano;
        _formData['km'] = product.km;
        _formData['cor'] = product.cor;
        _formData['preco'] = product.preco;
        _formData['descricao'] = product.descricao;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
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

  bool _isValidCPF(String cpf) {
    if (cpf.isEmpty) {
      return false;
    }

    // Remova caracteres não numéricos do CPF
    cpf = cpf.replaceAll(RegExp(r'\D'), '');

    if (cpf.length != 11) {
      return false;
    }

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1+$').hasMatch(cpf)) {
      return false;
    }

    // Calcula e verifica os dígitos verificadores
    int digit1 = _calculateCPFVerifierDigit(cpf.substring(0, 9));
    int digit2 =
        _calculateCPFVerifierDigit(cpf.substring(0, 9) + digit1.toString());

    return cpf.endsWith(digit1.toString() + digit2.toString());
  }

  int _calculateCPFVerifierDigit(String partialCPF) {
    List<int> cpfDigits =
        partialCPF.split('').map((e) => int.parse(e)).toList();

    int sum = 0;
    int weight = cpfDigits.length + 1;

    for (int digit in cpfDigits) {
      sum += digit * weight;
      weight--;
    }

    int remainder = sum % 11;

    return remainder < 2 ? 0 : 11 - remainder;
  }

  void updateImage() {
    setState(() {});
  }

  bool isValidImageUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');
    return isValidUrl && endsWithFile;
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

      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Ocorreu um erro!"),
          content: const Text("Ocorreu um erro para salvar o produto."),
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

  @override
  Widget build(BuildContext context) {
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
                      TextFormField(
                        initialValue: _formData['cpf']?.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Cpf',
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onSaved: (cpf) => _formData['cpf'] = cpf ?? '',
                        validator: (cpf) {
                          if (cpf == null) {
                            return 'CPF é obrigatório!';
                          }
                          if (!_isValidCPF(cpf)) {
                            return 'CPF inválido!';
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
                            groupValue: 'vehicle',
                            onChanged: (value) {},
                          ),
                          const Text('Novo'),
                          Radio(
                            value: 'Usado',
                            groupValue: 'vehicle',
                            onChanged: (value) {},
                          ),
                          const Text('Usado'),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Url da Imagem'),
                              focusNode: _imageUrlFocus,
                              controller: _imageUrlController,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.url,
                              onFieldSubmitted: (_) => _submitForm(),
                              onSaved: (imageUrl) =>
                                  _formData['imageUrl'] = imageUrl ?? '',
                              // ignore: no_leading_underscores_for_local_identifiers
                              validator: (_imageUrl) {
                                final imageUrl = _imageUrl ?? '';

                                if (!isValidImageUrl(imageUrl)) {
                                  return 'Informe uma Url válida';
                                }

                                return null;
                              },
                            ),
                          ),
                          Container(
                            height: 100,
                            width: 100,
                            margin: const EdgeInsets.only(
                              top: 10,
                              left: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: _imageUrlController.text.isEmpty
                                ? const Text('Informa a Url')
                                : Image.network(_imageUrlController.text),
                          ),
                        ],
                      ),
                      //**************************************** */
                      //ImageInput(_selectImage),
                      // Row(
                      //   children: [
                      //     Container(
                      //       width: 180,
                      //       height: 100,
                      //       decoration: BoxDecoration(
                      //         border: Border.all(
                      //           width: 1,
                      //           color: Colors.grey,
                      //         ),
                      //       ),
                      //       alignment: Alignment.center,
                      //       child: _storedImage != null
                      //           ? Image.file(
                      //               _storedImage!,
                      //               width: double.infinity,
                      //               fit: BoxFit.cover,
                      //             )
                      //           : const Text('Nenhum imagem!'),
                      //     ),
                      //     const SizedBox(width: 10),
                      //     TextButton.icon(
                      //       onPressed: _takePicture,
                      //       icon: const Icon(Icons.camera),
                      //       label: const Text('Tirar Foto'),
                      //       style: TextButton.styleFrom(
                      //         foregroundColor: Theme.of(context).colorScheme.primary,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      //**************************************** */

                      const SizedBox(height: 22),
                      const Padding(padding: EdgeInsets.all(2)),
                      Center(
                        child: SizedBox(
                          width: 300,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              _submitForm();
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
