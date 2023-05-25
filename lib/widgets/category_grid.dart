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
    categories = getCategories(provider);
    print("InitState Fired in Grid List");
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackEndProvider>(context);
    return FutureBuilder(
        future: categories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //print("<=======Categories=======> ${provider.categories}");
            if (provider.categories != null &&
                provider.categories!.isNotEmpty) {
              Map<String, dynamic>? categoriesPriceJson =
                  provider.categoriesPriceJson;
              Map<String, int> categoriesPriceMap = {};

              //Categories and price mapping
              for (var e in provider.categories!) {
                categoriesPriceMap.putIfAbsent(e.categoryname, () => 0);
                if (categoriesPriceJson![e.categoryname] != null) {
                  categoriesPriceMap.update(
                      e.categoryname,
                      (value) =>
                          value + categoriesPriceJson[e.categoryname] as int);
                }
              }

              List<Widget> categoryGrid = [];
              categoriesPriceMap.forEach((key, value) => categoryGrid.add(
                    FlipCardWidget(
                      name: key,
                      cost: "\$$value",
                    ),
                  ));
              return GridView.count(
                shrinkWrap: true,
                primary: false,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                children: <Widget>[...categoryGrid],
              );
            } else {
              return Center(
                child: Text("Now, Tap the Below \"+\" Button to add category"),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
