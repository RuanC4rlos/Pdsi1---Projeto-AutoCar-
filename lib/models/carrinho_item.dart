class CarrinhoItem {
  final String id;
  final String productId;
  final String name;
  final int quantity;
  final double price;
  final String imageUrl;
  CarrinhoItem(
      {required this.id,
      required this.productId,
      required this.name,
      required this.quantity,
      required this.price,
      required this.imageUrl});
}
