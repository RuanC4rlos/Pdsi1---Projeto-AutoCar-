import 'package:flutter/material.dart';

class Car with ChangeNotifier {
  num id;
  String fabricante;
  String modelo;
  String ano;
  String preco;
  String cor;
  String km;
  String descricao;
  String imageUrl;
  bool isFavorite;

  Car({
    required this.id,
    required this.fabricante,
    required this.modelo,
    required this.ano,
    required this.preco,
    required this.cor,
    required this.km,
    required this.descricao,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
