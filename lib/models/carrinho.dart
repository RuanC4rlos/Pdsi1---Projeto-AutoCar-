import 'dart:math';

import 'package:auto_car/models/car.dart';
import 'package:auto_car/models/carrinho_item.dart';
import 'package:flutter/material.dart';

class Carrinho with ChangeNotifier {
  late Map<String, CarrinhoItem> _items = {};
  Map<String, CarrinhoItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      // Convert price and quantity to double before multiplication
      double price = double.parse(cartItem.price.toString());
// assuming price is formatted as '50.000,00'
      double quantity = cartItem.quantity.toDouble();

      total += price * quantity;
    });
    return total;
  }

  void addItem(Car product) {
    final productIdString = product.id.toString();
    if (_items.containsKey(product.id)) {
      _items.update(
        productIdString,
        (existingItem) => CarrinhoItem(
          id: existingItem.id,
          productId: existingItem.productId,
          marca: existingItem.marca,
          modelo: existingItem.modelo,
          quantity: existingItem.quantity,
          price: existingItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        productIdString,
        () => CarrinhoItem(
          id: Random().nextInt(1000).toString(),
          productId: product.id,
          marca: product.marca,
          modelo: product.modelo,
          quantity: 1,
          price: product.preco,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
