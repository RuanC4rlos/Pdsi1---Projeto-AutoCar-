import 'package:auto_car/models/carrinho.dart';
import 'package:auto_car/models/carrinho_item.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class CarrinhoItemWidget extends StatelessWidget {
  const CarrinhoItemWidget({required this.cartItem, super.key});
  final CarrinhoItem cartItem;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      confirmDismiss: (_) {
        return showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Tem Certeza?"),
            content: const Text("Quer remover o item do carrinho?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text("Não"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: const Text("Sim"),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        Provider.of<Carrinho>(context, listen: false)
            .removeItem(cartItem.productId.toString());
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Column(
          children: [
            ListTile(
              title: Text('${cartItem.marca}  ${cartItem.modelo}'),
              subtitle:
                  Text('Total: R\$ ${cartItem.price * cartItem.quantity},'),
              trailing: Text('${cartItem.quantity}x'),
            ),
            const SizedBox(height: 20), // Espaço entre as imagens
            // Adicione outro ListTile aqui para a próxima imagem
          ],
        ),
      ),
    );
  }
}
