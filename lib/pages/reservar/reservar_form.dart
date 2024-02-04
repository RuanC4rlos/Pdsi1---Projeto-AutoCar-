// ignore_for_file: non_constant_identifier_names

import 'package:auto_car/components/app_drawer.dart';
import 'package:auto_car/components/bottom_navigation_bar.dart';
import 'package:auto_car/models/car_list.dart';
import 'package:auto_car/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class ReservarForm extends StatefulWidget {
  const ReservarForm({super.key});

  @override
  State<ReservarForm> createState() => _ReservarFormState();
}

class _ReservarFormState extends State<ReservarForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};
  bool _isLoading = false;

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
      ).saveReservar(_formData);
      //Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, AppRoutes.PROUCT_CAR);
    } catch (error) {
      // ignore: use_build_context_synchronously, avoid_print
      print('EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE');
      // ignore: avoid_print
      print('Error: $error');
      // ignore: avoid_print
      print('EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE');

      // ignore: use_build_context_synchronously
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
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final startDateStr =
        DateFormat('dd/MM/yyyy').parse(arguments['inicio'] as String);
    final endDateStr =
        DateFormat('dd/MM/yyyy').parse(arguments['final'] as String);
    int differenceInDays = endDateStr.difference(startDateStr).inDays;

    final String startDate = DateFormat('dd/MM/yyyy').format(startDateStr);
    final String endDate = DateFormat('dd/MM/yyyy').format(endDateStr);

    _formData['data'] = {'inicio': startDate, 'final': endDate};

    final id = arguments['id'];
    final marca = arguments['marca'];
    final modelo = arguments['modelo'];
    final preco = arguments['preco'];

    _formData['id'] = id;
    _formData['marca'] = marca;
    _formData['modelo'] = modelo;
    _formData['preco'] = preco * differenceInDays;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Formulário de reserva'),
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
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                        ),
                        textInputAction: TextInputAction.next,
                        onSaved: (nome) => _formData['nome'] = nome ?? '',
                        validator: (Nome) {
                          final nome = Nome ?? '';
                          if (nome.trim().isEmpty) {
                            return 'Nome é obrigatorio!';
                          }
                          return null;
                        },
                      ),

                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Endereço',
                        ),
                        textInputAction: TextInputAction.next,
                        onSaved: (endereco) =>
                            _formData['endereco'] = endereco ?? '',
                        validator: (Endereco) {
                          final endereco = Endereco ?? '';
                          if (endereco.trim().isEmpty) {
                            return 'Endereço é obrigatorio!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 26),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                MaskTextInputFormatter(
                                    mask: '(##)9 ####-####',
                                    filter: {"#": RegExp(r'[0-9]')})
                              ],
                              onSaved: (contato) =>
                                  _formData['contato'] = contato ?? '',
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Contato',
                              ),
                              validator: (Contato) {
                                final contato = Contato ?? '';
                                if (contato.trim().isEmpty) {
                                  return 'Contato é obrigatorio!';
                                }
                                final numberCount = contato
                                    .replaceAll(RegExp(r'\D'), '')
                                    .length;
                                if (numberCount != 11) {
                                  return 'Contato deve ter 11 dígitos!';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                MaskTextInputFormatter(
                                    mask: '###.###.###-##',
                                    filter: {"#": RegExp(r'[0-9]')})
                              ],
                              onSaved: (cpf) => _formData['cpf'] = cpf ?? '',
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'CPF',
                              ),
                              validator: (Cpf) {
                                final cpf = Cpf ?? '';
                                if (cpf.trim().isEmpty) {
                                  return 'Cpf é obrigatorio!';
                                }
                                final numberCount =
                                    cpf.replaceAll(RegExp(r'\D'), '').length;
                                if (numberCount != 11) {
                                  return 'CPF deve ter 11 dígitos!';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16.0),

                      const SizedBox(height: 52),
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
