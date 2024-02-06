import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:auto_car/exceptions/http_exception.dart';
import 'package:auto_car/models/place.dart';
import 'package:auto_car/models/reserva.dart';
import 'package:auto_car/utils/constants.dart';
import 'package:auto_car/utils/location_util.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:auto_car/models/car.dart';
import 'package:flutter/widgets.dart';

class CarList with ChangeNotifier {
  final String _token;
  final String _userId;
  DateTime? _expiryDate;

  final List<Car> _items;

  late List<Reserva> _itemsReservados;

  final List<Car> _itemsAlugado;

  late List<Map<String, dynamic>> _horariosReservados;
  CarList([
    this._token = '',
    this._userId = '',
    this._items = const [],
    this._itemsReservados = const [],
    this._horariosReservados = const [],
    List<Car>? _itemsAlugado,
  ]) : _itemsAlugado = _itemsAlugado ?? [];

  int get itemsCount {
    return _items.length;
  }

  bool _showFavoriteOnly = false;

  List<Car> get items {
    if (_showFavoriteOnly) {
      return _items.where((carItem) => carItem.isFavorite).toList();
    }
    return [..._items];
  }

  List<Car> get itemsAlugados {
    if (_showFavoriteOnly) {
      return _itemsAlugado.where((carItem) => carItem.isFavorite).toList();
    }
    return [..._itemsAlugado];
  }

  List<Reserva> get itemsReservados {
    return [..._itemsReservados];
  }

  List get horariosReservados {
    return [..._horariosReservados];
  }

  List<Car> get allItems {
    return [..._items, ..._itemsAlugado];
  }

  int get allItemsCount {
    return _items.length + _itemsAlugado.length;
  }

  int get itemsCountAlugado {
    return _itemsAlugado.length;
  }

  int get itemsCountReservados {
    return _itemsReservados.length;
  }

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return isValid;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

  Future<void> loadProducts() async {
    _items.clear();

    final response = await http
        .get(Uri.parse('${Constants.PRODUCT_VENDA_URL}.json?auth=$_token'));
    if (response.body == 'null') return;

    final favResponse = await http.get(
      Uri.parse('${Constants.USER_FAVORITES_URL}/$_userId.json/?auth=$_token'),
    );

    Map<String, dynamic> favData =
        favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) async {
      final isFavorite = favData[productId] ?? false;

      _items.add(
        Car(
          id: productId,
          apelido: productData['apelido'] ?? '',
          marca: productData['marca'] ?? '',
          modelo: productData['modelo'] ?? '',
          ano: productData['ano'] ?? '',
          preco: productData['preco'] ?? 0.0,
          cor: productData['cor'] ?? '',
          km: productData['km'] ?? '',
          descricao: productData['descricao'] ?? '',
          isFavorite: isFavorite,
          estado: productData['estado'] ?? 'Novo',
          isForRent: productData['isForRent'] ?? false,
        ),
      );
    });
    notifyListeners();
  }

  Future<void> loadProductsAlugados() async {
    _itemsAlugado.clear();

    final response = await http
        .get(Uri.parse('${Constants.PRODUCT_ALUGADO_URL}.json?auth=$_token'));
    if (response.body == 'null') return;

    final favResponse = await http.get(
      Uri.parse('${Constants.USER_FAVORITES_URL}/$_userId.json/?auth=$_token'),
    );

    Map<String, dynamic> favData =
        favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) async {
      final isFavorite = favData[productId] ?? false;
      LatLng location = LatLng(productData['location']['latitude'] ?? 0.0,
          productData['location']['longitude'] ?? 0.0);

      _itemsAlugado.add(
        Car(
          id: productId,
          apelido: productData['apelido'] ?? '',
          marca: productData['marca'] ?? '',
          modelo: productData['modelo'] ?? '',
          ano: productData['ano'] ?? '',
          preco: productData['preco'] ?? 0.0,
          cor: productData['cor'] ?? '',
          km: productData['km'] ?? '',
          descricao: productData['descricao'] ?? '',
          isFavorite: isFavorite,
          estado: productData['estado'] ?? 'Novo',
          location: location,
          isForRent: productData['isForRent'] ?? true,
        ),
      );
    });
    notifyListeners();
  }

  final List<Car> _userItems = [];

  List<Car> get userItems {
    return [..._userItems];
  }

  int get useritemsCount {
    return _userItems.length;
  }

  Future<void> loadUserProducts() async {
    _userItems.clear();

    final response = await http
        .get(Uri.parse('${Constants.PRODUCT_VENDA_URL}.json?auth=$_token'));
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
            apelido: productData['apelido'],
            marca: productData['marca'],
            modelo: productData['modelo'],
            ano: productData['ano'],
            preco: productData['preco'],
            cor: productData['cor'],
            km: productData['km'],
            descricao: productData['descricao'],
            isFavorite: isFavorite,
            estado: productData['estado'] ?? 'Novo',
            isForRent: productData['isForRent'],
          ),
        );
      }
    });
    notifyListeners();
  }

  Future<void> loadUserProductsAlugados() async {
    _userItems.clear();

    final response = await http
        .get(Uri.parse('${Constants.PRODUCT_ALUGADO_URL}.json?auth=$_token'));
    if (response.body == 'null') return;

    final favResponse = await http.get(
      Uri.parse('${Constants.USER_FAVORITES_URL}/$_userId.json/?auth=$_token'),
    );

    Map<String, dynamic> favData =
        favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);

    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((productId, productData) async {
      LatLng location = LatLng(productData['location']['latitude'] ?? 0.0,
          productData['location']['longitude'] ?? 0.0);

      final isFavorite = favData[productId] ?? false;
      if (productData['userId'] == _userId) {
        _userItems.add(
          Car(
            id: productId,
            apelido: productData['apelido'],
            marca: productData['marca'],
            modelo: productData['modelo'],
            ano: productData['ano'],
            preco: productData['preco'],
            cor: productData['cor'],
            km: productData['km'],
            descricao: productData['descricao'],
            isFavorite: isFavorite,
            estado: productData['estado'] ?? 'Novo',
            location: location,
            isForRent: productData['isForRent'],
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
      apelido: data['apelido'] as String,
      marca: data['marca'] as String,
      modelo: data['modelo'] as String,
      ano: data['ano'] as String,
      preco: data['preco'] as double,
      cor: data['cor'] as String,
      km: data['km'] as String,
      descricao: data['descricao'] as String,
      estado: data['estado'] as String,
      isForRent: false,
    );
    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> addProduct(Car product) async {
    final response = await http.post(
      Uri.parse('${Constants.PRODUCT_VENDA_URL}.json?auth=$_token'),
      body: jsonEncode(
        {
          "apelido": product.apelido,
          "marca": product.marca,
          "modelo": product.modelo,
          "ano": product.ano,
          "km": product.km,
          "cor": product.cor,
          "preco": product.preco,
          "descricao": product.descricao,
          "estado": product.estado,
          "userId": _userId,
          "isForRent": false,
        },
      ),
    );

    final id = jsonDecode(response.body)['id'];
    _items.add(
      Car(
        id: id ?? '', // ?? ''
        apelido: product.apelido,
        marca: product.marca,
        modelo: product.modelo,
        ano: product.ano,
        km: product.km,
        cor: product.cor,
        preco: product.preco,
        descricao: product.descricao,
        // imageUrl: product.imageUrl,
        estado: product.estado,
        isForRent: false,
      ),
    );
    notifyListeners();
  }

  Future<void> saveProductAlugado(Map<String, dynamic> data) {
    bool hasId = data['id'] != null;
    final product = Car(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      apelido: data['apelido'] as String,
      marca: data['marca'] as String,
      modelo: data['modelo'] as String,
      ano: data['ano'] as String,
      preco: data['preco'] as double,
      cor: data['cor'] as String,
      km: data['km'] as String,
      descricao: data['descricao'] as String,
      estado: data['estado'] as String,
      location: data['location'] as LatLng,
      isForRent: true,
    );
    if (hasId) {
      return updateProductAlugado(product);
    } else {
      return addProductAlugado(product);
    }
  }

  Future<void> addProductAlugado(Car product) async {
    final address =
        await LocationUtil.getAddressFrom(product.location as LatLng);
    final placeLocation = PlaceLocation(
      latitude: product.location!.latitude,
      longitude: product.location!.longitude,
      address: address,
    );
    final response = await http.post(
      Uri.parse('${Constants.PRODUCT_ALUGADO_URL}.json?auth=$_token'),
      body: jsonEncode(
        {
          "apelido": product.apelido,
          "marca": product.marca,
          "modelo": product.modelo,
          "ano": product.ano,
          "km": product.km,
          "cor": product.cor,
          "preco": product.preco,
          "descricao": product.descricao,
          // "imageUrl": product.imageUrl,
          "estado": product.estado,
          "location": placeLocation.toJson(),
          "isForRent": true,
          "userId": _userId,
        },
      ),
    );
    final id = jsonDecode(response.body)['id'];
    _itemsAlugado.add(
      Car(
        id: id ?? '', // ?? ''
        apelido: product.apelido,
        marca: product.marca,
        modelo: product.modelo,
        ano: product.ano,
        km: product.km,
        cor: product.cor,
        preco: product.preco,
        descricao: product.descricao,
        estado: product.estado,
        location: product.location,
        isForRent: product.isForRent,
      ),
    );

    notifyListeners();
  }

  Future<void> updateProduct(Car product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.PRODUCT_VENDA_URL}/${product.id}.json?auth=$_token'),
        body: jsonEncode(
          {
            "apelido": product.apelido,
            "marca": product.marca,
            "modelo": product.modelo,
            "ano": product.ano,
            "km": product.km,
            "cor": product.cor,
            "preco": product.preco,
            "descricao": product.descricao,
            "estado": product.estado,
          },
        ),
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> updateProductAlugado(Car product) async {
    final address =
        await LocationUtil.getAddressFrom(product.location as LatLng);
    final placeLocation = PlaceLocation(
      latitude: product.location!.latitude,
      longitude: product.location!.longitude,
      address: address,
    );
    int index = _itemsAlugado.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.PRODUCT_ALUGADO_URL}/${product.id}.json?auth=$_token'),
        body: jsonEncode(
          {
            "apelido": product.apelido,
            "marca": product.marca,
            "modelo": product.modelo,
            "ano": product.ano,
            "km": product.km,
            "cor": product.cor,
            "preco": product.preco,
            "descricao": product.descricao,
            "estado": product.estado,
            "location": placeLocation.toJson(),
          },
        ),
      );

      _itemsAlugado[index] = product;
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
            '${Constants.PRODUCT_VENDA_URL}/${product.id}.json?auth=$_token'),
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

  Future<void> removeProductAlugado(Car product) async {
    int index = _itemsAlugado.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _itemsAlugado[index];
      _itemsAlugado.remove(product);
      notifyListeners();
      final response = await http.delete(
        Uri.parse(
            '${Constants.PRODUCT_ALUGADO_URL}/${product.id}.json?auth=$_token'),
      );
      if (response.statusCode >= 400) {
        _itemsAlugado.insert(index, product);
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

  Future<List<String>> loadUserIds() async {
    final response = await http
        .get(Uri.parse('${Constants.PRODUCT_VENDA_URL}.json?auth=$_token'));
    if (response.body == 'null') return [];

    Map<String, dynamic> data = jsonDecode(response.body);
    List<String> userIds = [];

    data.forEach((productId, productData) {
      if (productData['userId'] != null) {
        userIds.add(productData['userId']);
      }
    });

    return userIds;
  }

// Reservar -----------------------------------------------------------
  Future<void> saveReservar(Map<String, dynamic> data) async {
    bool hasId = data['id'] != null;

    final product = Reserva(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      marca: data['marca'] as String,
      modelo: data['modelo'] as String,
      nome: data['nome'] as String,
      cpf: data['cpf'] as String,
      contato: data['contato'] as String,
      endereco: data['endereco'] as String,
      preco: data['preco'] as double,
      horario: data['data'],
    );

    await http.post(
      Uri.parse('${Constants.RESERVA_BASE_URL}/$_userId.json?auth=$_token'),
      body: jsonEncode(
        {
          "marca": product.marca,
          "modelo": product.modelo,
          "nome": product.nome,
          "cpf": product.cpf,
          "contato": product.contato,
          "endereco": product.endereco,
          "preco": product.preco,
          "data": product.horario,
        },
      ),
    );
  }

  Future<void> loadReserva() async {
    _itemsReservados = List.from(_itemsReservados);
    _itemsReservados.clear();
    _horariosReservados = List.from(_horariosReservados);
    _horariosReservados.clear();
    final response = await http.get(
        Uri.parse('${Constants.RESERVA_BASE_URL}/$_userId.json?auth=$_token'));
    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) async {
      // print('ProductId: $productId');
      // print('ProductData: $productData');
      _itemsReservados.add(
        Reserva(
          id: productId,
          marca: productData['marca'] ?? '',
          modelo: productData['modelo'] ?? '',
          nome: productData['nome'] ?? '',
          cpf: productData['cpf'] ?? '',
          contato: productData['contato'] ?? '',
          endereco: productData['endereco'] ?? '',
          preco: productData['preco'] ?? 0.0,
          horario: productData['data'] ?? '',
        ),
      );
      _horariosReservados = List.from(_horariosReservados);
      _horariosReservados.add(productData['data']);
    });
    notifyListeners();
  }

  Future<void> removeReserva(Reserva product, String usuarioId) async {
    int index = _itemsReservados.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _itemsReservados[index];
      _itemsReservados.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.RESERVA_BASE_URL}/$usuarioId/${product.id}.json?auth=$_token'),
      );
      if (response.statusCode >= 400) {
        _itemsReservados.insert(index, product);
        notifyListeners();
        throw HttpException(
            msg: 'Não foi possivel excluir o produto.',
            statusCode: response.statusCode);
      }
    }
  }

  // Future<void> removeReserva(Reserva product, String usuarioId) async {
  //   int index = _itemsReservados.indexWhere((p) => p.id == product.id);

  //   if (index >= 0) {
  //     final product = _itemsReservados[index];
  //     _itemsReservados.remove(product);
  //     notifyListeners();

  //     // Encontre o índice da reserva correspondente em _horariosReservados
  //     int horarioIndex = _horariosReservados.indexWhere((horario) =>
  //         horario['inicio'] == product.horario['inicio'] &&
  //         horario['final'] == product.horario['final']);

  //     // Remova a reserva de _horariosReservados
  //     if (horarioIndex >= 0) {
  //       _horariosReservados.removeAt(horarioIndex);
  //     }

  //     final response = await http.delete(
  //       Uri.parse(
  //           '${Constants.RESERVA_BASE_URL}/$usuarioId/${product.id}.json?auth=$_token'),
  //     );
  //     if (response.statusCode >= 400) {
  //       _itemsReservados.insert(index, product);
  //       _horariosReservados.insert(horarioIndex,
  //           product.horario); // Reinsira a reserva se a remoção falhar
  //       notifyListeners();
  //       throw HttpException(
  //           msg: 'Não foi possivel excluir o produto.',
  //           statusCode: response.statusCode);
  //     }
  //   }
  // }
}
