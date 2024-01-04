import 'dart:async';

import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  final StreamController<String> searchController;

  const Search({Key? key, required this.searchController}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      widget.searchController.add(_controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: _controller,
          onChanged: (value) {
            setState(() {});
            widget.searchController.add(value);
          },
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
