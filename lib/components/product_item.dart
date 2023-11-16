import 'package:auto_car/models/car.dart';
import 'package:auto_car/pages/product_detail_car_page.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final Car product;
  const ProductItem({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Adiciona bordas arredondadas
      ),
      elevation: 5, // Adiciona sombra ao cartão
      margin: const EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => ProductDetailCarPage(product: product),
            ),
          );
        },
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.asset(
                product.imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.fabricante,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900, // Altera a cor do texto
                    ),
                  ),
                  Text(
                    product.ano,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600, // Altera a cor do texto
                    ),
                  ),
                  Text(
                    product.modelo,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade800, // Altera a cor do texto
                    ),
                  ),
                  TextButton(
                    child: Text(
                      'Ver Mais',
                      style: TextStyle(color: Colors.blue.shade600),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) =>
                              ProductDetailCarPage(product: product),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
