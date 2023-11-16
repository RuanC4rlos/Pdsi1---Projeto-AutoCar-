import 'package:auto_car/models/car.dart';
import 'package:flutter/material.dart';

class ProductDetailCarPage extends StatelessWidget {
  const ProductDetailCarPage({required this.product, super.key});
  final Car product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.modelo),
      ),
      body: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: 200, // Altura da imagem
              child: Center(
                child: Image.asset(product.imageUrl,
                    fit: BoxFit.cover // Ajuste a imagem para preencher o espaço
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Marca',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ), // Rótulo 'Marca'
                      Text(
                        product.fabricante,
                      ), // Marca do carro
                    ],
                  ),
                  const SizedBox(
                    width: 90,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Ano ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                        product.ano,
                      ), // Ano do carro
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Modelo ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      product.modelo,
                    ), // Ano do carro
                  ],
                ),
                const SizedBox(width: 65),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Valor ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      product.preco,
                    ), // Ano do carro
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
