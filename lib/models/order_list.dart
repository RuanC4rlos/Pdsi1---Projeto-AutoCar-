import 'dart:convert';

import 'package:auto_car/models/carrinho.dart';
import 'package:auto_car/models/carrinho_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import 'order.dart';

class OrderList with ChangeNotifier {
  final String _token;
  final String _userId;
  late List<Order> _items;

  OrderList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    List<Order> items = [];

    final response = await http.get(
      Uri.parse('${Constants.ORDER_BASE_URL}/$_userId.json?auth=$_token'),
    );
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((orderId, orderData) {
      items.add(
        Order(
          id: orderId,
          date: DateTime.parse(orderData['date']),
          total: orderData['total'],
          products: (orderData['products'] as List<dynamic>).map((item) {
            return CarrinhoItem(
              id: item['id'],
              productId: item['productId'],
              marca: item['marca'],
              modelo: item['modelo'],
              quantity: item['quantify'],
              price: item['price'],
            );
          }).toList(),
        ),
      );
    });

    _items = items.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(Carrinho cart) async {
    final date = DateTime.now();
    final response = await http.post(
      Uri.parse('${Constants.ORDER_BASE_URL}/$_userId.json?auth=$_token'),
      body: jsonEncode(
        {
          'total': cart.totalAmount,
          'date': date.toIso8601String(),
          'products': cart.items.values
              .map((cartItem) => {
                    'id': cartItem.id,
                    'productId': cartItem.productId,
                    'marca': cartItem.marca,
                    'modelo': cartItem.modelo,
                    'quantify': cartItem.quantity,
                    'price': cartItem.price,
                  })
              .toList(),
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _items.insert(
      0,
      Order(
        id: id,
        total: cart.totalAmount,
        date: date,
        products: cart.items.values.toList(),
      ),
    );
    notifyListeners();
  }
}

// import 'dart:math';

// import 'package:auto_car/models/carrinho.dart';
// import 'package:flutter/material.dart';
// import 'order.dart';

// class OrderList with ChangeNotifier {
//   // final String _token;
//   // final String _userId;
//   // late final List<Order> _items;
//   final List<Order> _items;

//   OrderList([
//     List<Order>? items,
//   ]) : _items = items != null ? List.from(items) : [];

//   // OrderList([
//   //   // this._token = '',
//   //   // this._userId = '',
//   //   List<Order>? items,
//   // ]) : _items = List.from(items ?? []);

//   List<Order> get items {
//     return [..._items];
//   }

//   int get itemsCount {
//     return _items.length;
//   }

//   void addOrder(Carrinho cart) {
//     _items.insert(
//       0,
//       Order(
//         id: Random().nextDouble().toString(),
//         total: cart.totalAmount,
//         date: DateTime.now(),
//         products: cart.items.values.toList(),
//       ),
//     );
//     notifyListeners();
//   }
// }
