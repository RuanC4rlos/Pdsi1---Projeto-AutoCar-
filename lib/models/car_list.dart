import 'package:auto_car/data/dummy_data.dart';
import 'package:auto_car/models/car.dart';
import 'package:flutter/widgets.dart';

class CarList with ChangeNotifier {
  final List<Car> _items = dummyProducts;
  bool _showFavoriteOnly = false;

  List<Car> get items {
    if (_showFavoriteOnly) {
      return _items.where((carItem) => carItem.isFavorite).toList();
    }
    return [..._items];
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
