import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order.dart';

class OrderWidget extends StatefulWidget {
  final Order order;

  const OrderWidget({required this.order, super.key});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  late bool _expanded = false;
  double itemsHeight() {
    return (widget.order.products.length * 24.0) + 10;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded ? itemsHeight() + 80 : 80,
      child: Card(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: Text(
                    'R\$ ${NumberFormat("#,##0.00", "pt_BR").format(widget.order.total)}'),
                //'R\$ ${widget.order.total..toStringAsFixed(2)}'),
                subtitle: Text(
                  DateFormat('dd/MM/yyy hh:mm').format(widget.order.date),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                ),
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
                    children: widget.order.products.map(
                      (product) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${product.marca}  ${product.modelo}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${product.quantity}x   R\$ ${NumberFormat("#,##0.00", "pt_BR").format(widget.order.total)}',
                              // '${product.quantity}x    R\$ ${product.price}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        );
                      },
                    ).toList(),
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
