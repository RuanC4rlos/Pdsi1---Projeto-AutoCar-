import 'package:auto_car/models/car.dart';
import 'package:auto_car/pages/detail_car_page.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Car>(context);
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
              builder: (ctx) => DetailCarPage(product: product),
            ),
          );
        },
        child: Column(
          children: <Widget>[
            Stack(
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
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: IconButton(
                    onPressed: () {
                      product.toggleFavorite();
                    },
                    icon: Icon(
                      product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: 30,
                      color: const Color.fromARGB(255, 0, 0, 255),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 400,
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Alinha os textos à esquerda
                  children: [
                    Text(
                      product.fabricante,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 32, 46,
                              85) //Colors.blue.shade900, // Altera a cor do texto
                          ),
                    ),
                    Text(
                      product.ano,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Color.fromARGB(
                            255, 123, 123, 123), // Altera a cor do texto
                      ),
                    ),
                    Text(
                      product.modelo,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Color.fromARGB(
                            255, 123, 123, 123), // Altera a cor do texto
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                child: const Text(
                  'Ver Mais',
                  style: TextStyle(
                      fontSize: 17, color: Color.fromARGB(255, 0, 0, 255)),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => DetailCarPage(product: product),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
