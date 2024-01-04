// ignore_for_file: depend_on_referenced_packages

import 'package:auto_car/components/bottom_navigation_bar.dart';
import 'package:auto_car/data/dummy_data.dart';
import 'package:auto_car/models/car.dart';
import 'package:auto_car/models/carrinho.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DetailCarPage extends StatefulWidget {
  const DetailCarPage({required this.product, super.key});
  final Car product;

  @override
  State<DetailCarPage> createState() => _DetailCarPageState();
}

class _DetailCarPageState extends State<DetailCarPage> {
  final List<Car> loadedProducts = dummyProducts;

  @override
  Widget build(BuildContext context) {
    final carrinho = Provider.of<Carrinho>(context);
    final precoFormatado = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
        .format(widget.product.preco);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.product.modelo,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 320, // Altura da imagem
                    child: Center(
                      child: Image.network(widget.product.imageUrl,
                          fit: BoxFit
                              .cover // Ajuste a imagem para preencher o espaço
                          ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Marca',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 32, 46, 85),
                          ),
                        ), // Rótulo 'Marca'
                        Text(
                          widget.product.marca,
                          style: const TextStyle(fontSize: 16),
                        ), // Marca do carro
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(15)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Ano ',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 32, 46, 85),
                            )),
                        Text(
                          widget.product.ano,
                          style: const TextStyle(fontSize: 16),
                        ), // Ano do carro
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(15)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'km ',
                          style: TextStyle(
                            fontSize: 19,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 32, 46, 85),
                          ),
                        ),
                        Text(
                          widget.product.km,
                          style: const TextStyle(fontSize: 16),
                        ), // Ano do carro
                      ],
                    ),
                    const Padding(padding: EdgeInsets.all(15)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Cor ',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 32, 46, 85),
                          ),
                        ),
                        Text(
                          widget.product.cor,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ), // Ano do carro
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.all(20)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.only(left: 325)),
                  const Text(
                    'Valor ',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
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
                  onPressed: () {
                    // Coloque aqui a ação que deve ser executada ao pressionar o botão
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    // Cor de fundo
                  ),
                  child: Text(
                    'Comprar',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 19,
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(2)),
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
                        color: Theme.of(context).colorScheme.primary, width: 2),
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
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(20)),
              SizedBox(
                width: 350,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Descrição: ',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 32, 46, 85),
                      ),
                    ),
                    Text(
                      widget.product.descricao,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ), // Ano do carro
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
