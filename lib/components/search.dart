// ignore_for_file: unused_field

import 'dart:async';

import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  final StreamController<String> searchController;

  final Function(RangeValues, String, int, int, String, String)
      onFiltersChanged;
  final IconData selected;
  const Search({
    Key? key,
    required this.searchController,
    required this.selected,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SearchState createState() => _SearchState();
}

// class ColorButton extends StatelessWidget {
//   final Color color;
//   final String label;

//   const ColorButton({super.key, required this.color, required this.label});

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30.0),
//         ),
//       ),
//       onPressed: () {},
//       child: Text(label),
//     );
//   }
// }
class ColorButton extends StatelessWidget {
  final Color color;
  final String label;
  final bool selected;
  final VoidCallback onPressed;
  const ColorButton({
    Key? key,
    required this.color,
    required this.label,
    required this.selected,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide(
            color: selected ? Colors.red : Colors.transparent, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          color == Colors.white
              ? Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: color,
                    radius: 10,
                  ),
                )
              : CircleAvatar(
                  backgroundColor: color,
                  radius: 10,
                ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class _SearchState extends State<Search> {
  final TextEditingController _controller = TextEditingController();
  RangeValues _priceRange = const RangeValues(0, 100000);
  late String _selectedColor = 'All';

  // Adicione um mapa para armazenar o estado de seleção dos botões
  late Map<String, bool> _buttonSelected = {};

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      widget.searchController.add(_controller.text);
    });
  }

  void _showFilterDialog(BuildContext context) {
    String? estado;
    String? opcao;
    int ano = 2000;
    int km = 0;
    String cor = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text(
                'Filtrar Pesquisa',
              ),
              content: SizedBox(
                height: 470, // Defina a altura aqui
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Divider(),
                    const Text(
                      'Preço',
                      style: TextStyle(fontWeight: FontWeight.w900),
                      textAlign: TextAlign.start,
                    ),
                    RangeSlider(
                      min: 0,
                      max: 100000,
                      values: _priceRange,
                      onChanged: (RangeValues values) {
                        setState(() {
                          _priceRange = values;
                        });
                      },
                      divisions: 100,
                      labels: RangeLabels(
                        '${_priceRange.start.round()}',
                        '${_priceRange.end.round()}',
                      ),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Min\n0,00',
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          'Max\n  100.000,00',
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    const Text(
                      'Ano',
                      style: TextStyle(fontWeight: FontWeight.w900),
                      textAlign: TextAlign.start,
                    ),

                    // Ano
                    Slider(
                      value: ano.toDouble(),
                      min: 2000,
                      max: 2024,
                      divisions: 24,
                      label: ano.round().toString(),
                      onChanged: (double newValue) {
                        setState(() {
                          ano = newValue.round();
                        });
                      },
                    ),

                    const Padding(padding: EdgeInsets.all(10)),
                    const Text(
                      'Km',
                      style: TextStyle(fontWeight: FontWeight.w900),
                      textAlign: TextAlign.start,
                    ),
                    // Km
                    Slider(
                      value: km.toDouble(),
                      min: 0,
                      max: 200000,
                      divisions: 200,
                      label: km.round().toString(),
                      onChanged: (double newValue) {
                        setState(() {
                          km = newValue.round();
                        });
                      },
                    ),
                    const Padding(padding: EdgeInsets.all(10)),
                    const Text(
                      'Cor:',
                      style: TextStyle(fontWeight: FontWeight.w900),
                      textAlign: TextAlign.start,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          ColorButton(
                            color: Colors.red,
                            label: 'red',
                            selected: _buttonSelected['Red'] ?? false,
                            onPressed: () {
                              setState(() {
                                if (_buttonSelected['Red'] == true) {
                                  _buttonSelected['Red'] = false;
                                  cor = '';
                                } else {
                                  _buttonSelected = {
                                    'Red': true,
                                    'green': false,
                                    'blue': false,
                                    'grey': false,
                                    'Yellow': false,
                                    'branco': false,
                                  };
                                  cor = 'vermelho';
                                }
                              });
                            },
                          ),
                          ColorButton(
                            color: Colors.yellow,
                            label: 'yellow',
                            selected: _buttonSelected['yellow'] ?? false,
                            onPressed: () {
                              setState(() {
                                if (_buttonSelected['yellow'] == true) {
                                  _buttonSelected['yellow'] = false;
                                  cor = '';
                                } else {
                                  _buttonSelected = {
                                    'Red': false,
                                    'green': false,
                                    'blue': false,
                                    'grey': false,
                                    'yellow': true,
                                    'branco': false,
                                  };
                                  cor = 'amarelo';
                                }
                              });
                            },
                          ),
                          ColorButton(
                            color: Colors.green,
                            label: 'green',
                            selected: _buttonSelected['green'] ?? false,
                            onPressed: () {
                              setState(() {
                                if (_buttonSelected['green'] == true) {
                                  _buttonSelected['green'] = false;
                                  cor = '';
                                } else {
                                  _buttonSelected = {
                                    'Red': false,
                                    'green': true,
                                    'blue': false,
                                    'grey': false,
                                    'Yellow': false,
                                    'branco': false,
                                  };
                                  cor = 'verde';
                                }
                              });
                            },
                          ),
                          ColorButton(
                            color: Colors.blue,
                            label: 'blue',
                            selected: _buttonSelected['blue'] ?? false,
                            onPressed: () {
                              setState(() {
                                if (_buttonSelected['blue'] == true) {
                                  _buttonSelected['blue'] = false;
                                  cor = '';
                                } else {
                                  _buttonSelected = {
                                    'Red': false,
                                    'green': false,
                                    'blue': true,
                                    'grey': false,
                                    'Yellow': false,
                                    'branco': false,
                                  };
                                  cor = 'azul';
                                }
                              });
                            },
                          ),
                          ColorButton(
                            color: Colors.white,
                            label: 'white',
                            selected: _buttonSelected['white'] ?? false,
                            onPressed: () {
                              setState(() {
                                if (_buttonSelected['white'] == true) {
                                  _buttonSelected['white'] = false;
                                  cor = '';
                                } else {
                                  _buttonSelected = {
                                    'Red': false,
                                    'green': false,
                                    'blue': false,
                                    'grey': false,
                                    'Yellow': false,
                                    'white': true,
                                  };
                                  cor = 'branco';
                                }
                              });
                            },
                          ),
                          ColorButton(
                            color: Colors.grey,
                            label: 'grey',
                            selected: _buttonSelected['grey'] ?? false,
                            onPressed: () {
                              setState(() {
                                if (_buttonSelected['grey'] == true) {
                                  _buttonSelected['grey'] = false;
                                  cor = '';
                                } else {
                                  _buttonSelected = {
                                    'Red': false,
                                    'green': false,
                                    'blue': false,
                                    'grey': true,
                                    'Yellow': false,
                                    'branco': false,
                                  };
                                  cor = 'cinza';
                                }
                              });
                            },
                          ),
                          // ... repita para os outros botões
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text(
                                'Estado',
                                style: TextStyle(fontWeight: FontWeight.w900),
                                textAlign: TextAlign.start,
                              ),
                              // Estado
                              DropdownButton<String>(
                                value: estado,
                                onChanged: (newValue) {
                                  setState(() {
                                    estado = newValue!;
                                  });
                                },
                                items: <String?>[null, 'Novo', 'Usado']
                                    .map<DropdownMenuItem<String>>(
                                        (String? value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value ?? 'Selecione'),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                'Opção de Compra',
                                style: TextStyle(fontWeight: FontWeight.w900),
                                textAlign: TextAlign.start,
                              ),
                              // Estado
                              DropdownButton<String>(
                                value: opcao,
                                onChanged: (newValue) {
                                  setState(() {
                                    opcao = newValue!;
                                  });
                                },
                                items: <String?>[null, 'Venda', 'Aluguel']
                                    .map<DropdownMenuItem<String>>(
                                        (String? value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value ?? 'Selecione'),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Resetar'),
                  onPressed: () {
                    setState(() {
                      _priceRange = const RangeValues(0, 100000);
                      _selectedColor = 'All';
                      // Resetar todos os botões
                      _buttonSelected.clear();
                      estado = null;
                      ano = 2000;
                      km = 0;
                    });
                  },
                ),
                ElevatedButton(
                  child: const Text('Aplicar'),
                  onPressed: () {
                    // Aqui você pode aplicar os valores dos filtros
                    widget.onFiltersChanged(_priceRange, estado ?? 'Selecione',
                        ano, km, cor, opcao ?? 'Selecione');

                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: _controller,
          onChanged: (value) {
            setState(() {});
            widget.searchController.add(value);
          },
          decoration: InputDecoration(
            hintText: 'Pesquise por uma marca',
            hintStyle: const TextStyle(fontSize: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.only(
              left: 30,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 24.0, left: 16.0),
              child: widget.selected == Icons.filter_list
                  ? IconButton(
                      icon: const Icon(
                        Icons.filter_list,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        Future.delayed(const Duration(milliseconds: 50), () {
                          _showFilterDialog(context);
                        });
                      })
                  : const Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
