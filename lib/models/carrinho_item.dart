class CarrinhoItem {
  final int id;
  final num productId;
  final String name;
  final int quantity;
  final String price;
  final String imageUrl;
  CarrinhoItem(
      {required this.id,
      required this.productId,
      required this.name,
      required this.quantity,
      required this.price,
      required this.imageUrl});
}
