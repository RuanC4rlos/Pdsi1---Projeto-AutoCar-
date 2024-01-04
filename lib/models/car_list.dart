import 'dart:async';
import 'dart:convert';
import 'dart:math';
// ignore: depend_on_referenced_packages
import 'package:auto_car/exceptions/http_exception.dart';
import 'package:auto_car/utils/constants.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:auto_car/models/car.dart';
import 'package:flutter/widgets.dart';

class CarList with ChangeNotifier {
  final String _token;
  final String _userId;

  final List<Car> _items;
  bool _showFavoriteOnly = false;

  List<Car> get items {
    if (_showFavoriteOnly) {
      return _items.where((carItem) => carItem.isFavorite).toList();
    }
    return [..._items];
  }

  CarList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);
  int get itemsCount {
    return _items.length;
  }

  Future<void> loadProducts() async {
    _items.clear();

    final response = await http
        .get(Uri.parse('${Constants.PRODUCT_BASE_URL}.json?auth=$_token'));
    if (response.body == 'null') return;

    final favResponse = await http.get(
      Uri.parse('${Constants.USER_FAVORITES_URL}/$_userId.json/?auth=$_token'),
    );

    Map<String, dynamic> favData =
        favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      final isFavorite = favData[productId] ?? false;
      _items.add(
        Car(
          id: productId,
          cpf: productData['cpf'] ?? '',
          marca: productData['marca'] ?? '',
          modelo: productData['modelo'] ?? '',
          ano: productData['ano'] ?? '',
          preco: productData['preco'] ?? 0.0,
          cor: productData['cor'] ?? '',
          km: productData['km'] ?? '',
          descricao: productData['descricao'] ?? '',
          imageUrl: productData['imageUrl'] ?? '',
          isFavorite: isFavorite,
        ),
      );
    });
    notifyListeners();
  }

  final List<Car> _userItems = [];

  List<Car> get userItems {
    return [..._userItems];
  }

  Future<void> loadUserProducts() async {
    _userItems.clear();

    final response = await http
        .get(Uri.parse('${Constants.PRODUCT_BASE_URL}.json?auth=$_token'));
    if (response.body == 'null') return;

    final favResponse = await http.get(
      Uri.parse('${Constants.USER_FAVORITES_URL}/$_userId.json/?auth=$_token'),
    );

    Map<String, dynamic> favData =
        favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);

    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((productId, productData) {
      final isFavorite = favData[productId] ?? false;
      if (productData['userId'] == _userId) {
        _userItems.add(
          Car(
            id: productId,
            cpf: productData['cpf'],
            marca: productData['marca'],
            modelo: productData['modelo'],
            ano: productData['ano'],
            preco: productData['preco'],
            cor: productData['cor'],
            km: productData['km'],
            descricao: productData['descricao'],
            imageUrl: productData['imageUrl'],
            isFavorite: isFavorite,
          ),
        );
      }
    });
    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Car(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      cpf: data['cpf'] as String,
      marca: data['marca'] as String,
      modelo: data['modelo'] as String,
      ano: data['ano'] as String,
      preco: data['preco'] as double,
      cor: data['cor'] as String,
      km: data['km'] as String,
      descricao: data['descricao'] as String,
      imageUrl: data['imageUrl'] as String,
    );
    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> addProduct(Car product) async {
    final response = await http.post(
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json?auth=$_token'),
      body: jsonEncode(
        {
          "cpf": product.cpf,
          "marca": product.marca,
          "modelo": product.modelo,
          "ano": product.ano,
          "km": product.km,
          "cor": product.cor,
          "preco": product.preco,
          "descricao": product.descricao,
          "imageUrl": product.imageUrl,
          "userId": _userId,
        },
      ),
    );

    final id = jsonDecode(response.body)['id'];
    _items.add(
      Car(
        id: id ?? '', // ?? '' possivel erro no futuro
        cpf: product.cpf,
        marca: product.marca,
        modelo: product.modelo,
        ano: product.ano,
        km: product.km,
        cor: product.cor,
        preco: product.preco,
        descricao: product.descricao,
        imageUrl: product.imageUrl,
      ),
    );
    notifyListeners();
  }

  Future<void> updateProduct(Car product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token'),
        body: jsonEncode(
          {
            "cpf": product.cpf,
            "marca": product.marca,
            "modelo": product.modelo,
            "ano": product.ano,
            "km": product.km,
            "cor": product.cor,
            "preco": product.preco,
            "descricao": product.descricao,
            "imageUrl": product.imageUrl,
          },
        ),
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(Car product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token'),
      );
      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException(
            msg: 'Não foi possivel excluir o produto.',
            statusCode: response.statusCode);
      }
    }
  }

  void showFavoritesOnly() {
    _showFavoriteOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoriteOnly = false;
    notifyListeners();
  }
}
