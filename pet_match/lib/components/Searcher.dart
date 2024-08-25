import 'package:flutter/material.dart';

class Searcher extends StatefulWidget {
  @override
  SearcherState createState() => SearcherState();
}

class SearcherState extends State<Searcher> {
  TextEditingController searchController = TextEditingController();
  String busqueda = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (text) {
            setState(() {
              busqueda = text;
            });
          },
        ),
      ),
    );
  }
}
