import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/app_provider.dart';
import 'flipcard_widget.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  late Future<String> categories;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final provider = Provider.of<BackEndProvider>(context, listen: false);
    // final provider = Provider.of<BackEndProvider>(context, listen: false);
    categories = getCategories(provider);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackEndProvider>(context);
    return FutureBuilder(
        future: categories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic>? categoriesPriceJson =
                provider.categoriesPriceJson;
            List<Map<String, int>> categoriesPriceList = [];
            for (var e in provider.categories!) {
              {
                print(categoriesPriceJson![e.categoryname]);
                if (categoriesPriceJson[e.categoryname] != null) {
                } else {
                  categoriesPriceList.add({e.categoryname: 0});
                }
              }
            }
            return GridView.count(
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              children: <Widget>[
                ...categoriesPriceList.map(
                  (e) => FlipCardWidget(
                    name: e.keys.first,
                    cost: "\$${e.values.first}",
                  ),
                )
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
