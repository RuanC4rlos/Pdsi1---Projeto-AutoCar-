class CarrinhoItem {
  final String id;
  final String productId;
  final String marca;
  final String modelo;

  final int quantity;
  final double price;
  CarrinhoItem({
    required this.id,
    required this.productId,
    required this.marca,
    required this.modelo,
    required this.quantity,
    required this.price,
  });
}
