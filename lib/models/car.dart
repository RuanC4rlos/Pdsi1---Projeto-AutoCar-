class Car {
  num id;
  String fabricante;
  String modelo;
  String ano;
  String preco;
  String imageUrl;
  bool isFavorite;

  Car({
    required this.id,
    required this.fabricante,
    required this.modelo,
    required this.ano,
    required this.preco,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }
}
