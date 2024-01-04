import 'dart:convert';

import 'package:auto_car/utils/constants.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class Car with ChangeNotifier {
  String id;
  String cpf;
  String marca;
  String modelo;
  String ano;
  double preco;
  String cor;
  String km;
  String descricao;
  String imageUrl;
  bool isFavorite;

  Car({
    required this.id,
    required this.cpf,
    required this.marca,
    required this.modelo,
    required this.ano,
    required this.preco,
    required this.cor,
    required this.km,
    required this.descricao,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token, String userId) async {
    try {
      _toggleFavorite();

      final response = await http.put(
        Uri.parse(
            '${Constants.USER_FAVORITES_URL}/$userId/$id.json?auth=$token'),
        body: jsonEncode(isFavorite),
      );

      if (response.statusCode >= 400) {
        _toggleFavorite();
      }
    } catch (_) {
      _toggleFavorite();
    }
  }
}
