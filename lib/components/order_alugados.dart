import 'package:auto_car/exceptions/http_exception.dart';
import 'package:auto_car/models/car_list.dart';
import 'package:auto_car/models/reserva.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderAlugados extends StatefulWidget {
  final Reserva order;

  const OrderAlugados({required this.order, super.key});

  @override
  State<OrderAlugados> createState() => _OrderAlugadosState();
}

class _OrderAlugadosState extends State<OrderAlugados> {
  late bool _expanded = false;

  // Future<void> loadData() async {
  //   final reserv = Provider.of<CarList>(context, listen: false);
  //   await reserv.loadReserva();
  // }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   loadData();
  // }

  double itemsHeight() {
    final reservados = Provider.of<CarList>(context, listen: false);
    return (reservados.itemsCountReservados * 24.0) + 10;
  }

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
    // Obtenha o horário do objeto order
    Map<String, dynamic> horarioMap = widget.order.horario;

    DateFormat originalFormat = DateFormat('dd/MM/yyyy');

    DateTime inicio = originalFormat.parse(horarioMap['inicio']);
    DateTime fim = originalFormat.parse(horarioMap['final']);

    String formattedInicio = originalFormat.format(inicio);
    String formattedFim = originalFormat.format(fim);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded ? itemsHeight() + 50 : 80,
      child: Card(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title:
                          Text('R\$ ${widget.order.preco..toStringAsFixed(2)}'),
                      subtitle: Text(
                          'Data de Partida : $formattedInicio\nData de Entrega: $formattedFim'),
                      trailing: IconButton(
                        icon: const Icon(Icons.expand_more),
                        onPressed: () {
                          setState(() {
                            _expanded = !_expanded;
                          });
                        },
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
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
                                  ).removeReserva(widget.order);
                                  Navigator.of(ctx).pop();
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
                                ).removeReserva(widget.order);
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
                      icon: const Icon(Icons.delete, color: Colors.red)),
                ],
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  height: _expanded ? itemsHeight() : 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 4,
                  ),
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${widget.order.marca}  ${widget.order.modelo}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '    R\$ ${widget.order.preco.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
