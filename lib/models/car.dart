import 'dart:convert';
import 'package:auto_car/utils/constants.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class Car with ChangeNotifier {
  String id;
  String apelido;
  String marca;
  String modelo;
  String ano;
  double preco;
  String cor;
  String km;
  String descricao;
  bool isFavorite;
  String estado;
  LatLng? location;
  bool isForRent;

  Car({
    required this.id,
    required this.apelido,
    required this.marca,
    required this.modelo,
    required this.ano,
    required this.preco,
    required this.cor,
    required this.km,
    required this.descricao,
    this.isFavorite = false,
    required this.estado,
    this.location,
    required this.isForRent,
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
