import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: const TextStyle(fontSize: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.only(
              left: 30,
            ),
            suffixIcon: const Padding(
              padding: EdgeInsets.only(right: 24.0, left: 16.0),
              child: Icon(
                Icons.search,
                color: Colors.black,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
