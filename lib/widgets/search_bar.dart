import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SizedBox(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
                //contentPadding: EdgeInsets.symmetric(horizontal: 5),
                isDense: true,
                hintText: 'Search',
                suffixIcon:
                    InkWell(onTap: () {}, child: const Icon(Icons.search)),
                suffixIconConstraints: const BoxConstraints(
                  minHeight: 30,
                  minWidth: 30,
                ),
                border: InputBorder.none),
          ),
        ),
      ),
    );
  }
}
